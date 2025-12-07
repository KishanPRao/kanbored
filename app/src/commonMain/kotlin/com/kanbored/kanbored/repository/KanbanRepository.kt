package com.kanbored.kanbored.repository

import com.kanbored.kanbored.model.KanbanProject
import com.kanbored.kanbored.network.ApiProvider
import com.kanbored.kanbored.network.Result
import com.kanbored.kanbored.persistent.KanbanDatabase
import com.kanbored.kanbored.utils.PresentableText
import kanbored.app.generated.resources.Res
import kanbored.app.generated.resources.login_err_unknown
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.currentCoroutineContext
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.distinctUntilChanged
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.isActive
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class KanbanRepository @Inject constructor(
    // TODO: db or all DAOs?
    private val database: KanbanDatabase,
    private val apiProvider: ApiProvider,
) {
    companion object {
        const val API_POLL_INTERVAL_MS = 5_000L
    }

    private val pollingScope: CoroutineScope = CoroutineScope(Dispatchers.IO)

    fun pollApiReachability(
        intervalMs: Long = API_POLL_INTERVAL_MS
    ): StateFlow<Boolean> {
        return flow {
            while (currentCoroutineContext().isActive) {
                val isReachable: Boolean = apiProvider.isApiReachable()
                emit(isReachable)
                delay(intervalMs)
            }
        }
            .distinctUntilChanged()
            .stateIn(
                scope = pollingScope,
                started = SharingStarted.Eagerly,
                initialValue = true
            )
    }

    fun getAllProjects(): Flow<List<KanbanProject>> = database.projectDao().getAllProjects()

    suspend fun refreshProjects(): Result<Unit> {
        try {
            val response = apiProvider.getKanbanApi().getAllProjects()
            if (response.result != null) {
                val projects = response.result
                println("all projects: $projects")
                database.projectDao().insertAll(projects)
                return Result.Success(Unit)
            } else if (response.error != null) {
                return Result.Error(PresentableText.DynamicString(response.error.message))
            } else {
                return Result.Error(PresentableText.DynamicResource(Res.string.login_err_unknown))
            }
        } catch (e: Exception) {
            println("refreshProjects error: ${e.message}")
            return Result.Error(
                e.message?.let { PresentableText.DynamicString(it) }
                    ?: PresentableText.DynamicResource(Res.string.login_err_unknown)
            )
        }
    }
}