package com.kanbored.kanbored.repository

import com.kanbored.kanbored.model.KanbanColumn
import com.kanbored.kanbored.model.KanbanProject
import com.kanbored.kanbored.model.KanbanTask
import com.kanbored.kanbored.network.ApiProvider
import com.kanbored.kanbored.network.Result
import com.kanbored.kanbored.persistent.KanbanDatabase
import com.kanbored.kanbored.utils.PresentableText
import kanbored.app.generated.resources.Res
import kanbored.app.generated.resources.error_unknown
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

    fun getColumns(projectId: Int): Flow<List<KanbanColumn>> =
        database.columnDao().getColumns(projectId)

    fun getTasks(projectId: Int, columnId: Int): Flow<List<KanbanTask>> =
        database.taskDao().getTasks(projectId, columnId)

    fun getTask(projectId: Int, columnId: Int, taskId: Int): Flow<KanbanTask?> =
        database.taskDao().getTaskSync(projectId, columnId, taskId)

    suspend fun refreshProjects(): Result<Unit> {
        try {
            val response = apiProvider.kanbanApi.getAllProjects()
            if (response.result != null) {
                val projects = response.result
                println("all projects: $projects")
                database.projectDao().insertAll(projects)
                return Result.Success(Unit)
            } else if (response.error != null) {
                return Result.Error(PresentableText.DynamicString(response.error.message))
            } else {
                return Result.Error(PresentableText.DynamicResource(Res.string.error_unknown))
            }
        } catch (e: Exception) {
            println("refreshProjects error: ${e.message}")
            return Result.Error(
                e.message?.let { PresentableText.DynamicString(it) }
                    ?: PresentableText.DynamicResource(Res.string.error_unknown)
            )
        }
    }

    suspend fun refreshColumns(projectId: Int): Result<Unit> {
        try {
            val response = apiProvider.kanbanApi.getColumns(projectId)
            if (response.result != null) {
                val columns = response.result
                println("all columns: $columns")
                database.columnDao().insertAll(columns)
                return Result.Success(Unit)
            } else if (response.error != null) {
                return Result.Error(PresentableText.DynamicString(response.error.message))
            } else {
                return Result.Error(PresentableText.DynamicResource(Res.string.error_unknown))
            }
        } catch (e: Exception) {
            println("refreshColumns error: ${e.message}")
            return Result.Error(
                e.message?.let { PresentableText.DynamicString(it) }
                    ?: PresentableText.DynamicResource(Res.string.error_unknown)
            )
        }
    }

    suspend fun refreshTasks(projectId: Int, isArchived: Boolean): Result<Unit> {
        try {
            val response = apiProvider.kanbanApi.getAllTasks(projectId, isArchived)
            if (response.result != null) {
                val tasks = response.result
                println("all tasks: $tasks")
                database.taskDao().insertAll(tasks)
                return Result.Success(Unit)
            } else if (response.error != null) {
                return Result.Error(PresentableText.DynamicString(response.error.message))
            } else {
                return Result.Error(PresentableText.DynamicResource(Res.string.error_unknown))
            }
        } catch (e: Exception) {
            println("refreshTasks error: ${e.message}")
            return Result.Error(
                e.message?.let { PresentableText.DynamicString(it) }
                    ?: PresentableText.DynamicResource(Res.string.error_unknown)
            )
        }
    }

    suspend fun createProject(name: String): Result<Unit> {
        try {
            val response = apiProvider.kanbanApi.createProject(name)
            if (response.result != null) {
                val projectId = response.result
                println("createProject: $projectId")
                return Result.Success(Unit)
            } else if (response.error != null) {
                return Result.Error(PresentableText.DynamicString(response.error.message))
            } else {
                return Result.Error(PresentableText.DynamicResource(Res.string.error_unknown))
            }
        } catch (e: Exception) {
            println("createProject error: ${e.message}")
            return Result.Error(
                e.message?.let { PresentableText.DynamicString(it) }
                    ?: PresentableText.DynamicResource(Res.string.error_unknown)
            )
        }
    }
}