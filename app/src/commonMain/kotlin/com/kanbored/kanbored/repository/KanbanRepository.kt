package com.kanbored.kanbored.repository

import com.kanbored.kanbored.model.KanbanColumn
import com.kanbored.kanbored.model.KanbanComment
import com.kanbored.kanbored.model.KanbanProject
import com.kanbored.kanbored.model.KanbanSubtask
import com.kanbored.kanbored.model.KanbanTask
import com.kanbored.kanbored.network.ApiProvider
import com.kanbored.kanbored.network.ApiWorkManager
import com.kanbored.kanbored.network.KanbanError
import com.kanbored.kanbored.network.KanbanResponse
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
    private val apiWorkManager: ApiWorkManager,
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

    fun getAllProjects(): Flow<List<KanbanProject>> = database.projectDao().getAll()

    fun getColumns(projectId: Int): Flow<List<KanbanColumn>> = database.columnDao().get(projectId)

    fun getTasks(projectId: Int, columnId: Int): Flow<List<KanbanTask>> =
        database.taskDao().get(projectId, columnId)

    fun getTask(projectId: Int, columnId: Int, taskId: Int): Flow<KanbanTask?> =
        database.taskDao().getSingle(projectId, columnId, taskId)

    fun getSubtasks(taskId: Int): Flow<List<KanbanSubtask>> =
        database.subtaskDao().get(taskId)

    fun getComments(taskId: Int): Flow<List<KanbanComment>> =
        database.commentDao().get(taskId)

    suspend fun <T> refreshApi(
        apiInvoke: suspend () -> KanbanResponse<List<T>, KanbanError>,
        successInvoke: suspend (List<T>) -> Unit
    ): Result<Unit> {
        try {
            val response = apiInvoke()
            if (response.result != null) {
                successInvoke(response.result)
                return Result.Success(Unit)
            } else if (response.error != null) {
                return Result.Error(PresentableText.DynamicString(response.error.message))
            } else {
                return Result.Error(PresentableText.DynamicResource(Res.string.error_unknown))
            }
        } catch (e: Exception) {
            println("refreshApi error: ${e.message}")
            return Result.Error(
                e.message?.let { PresentableText.DynamicString(it) }
                    ?: PresentableText.DynamicResource(Res.string.error_unknown)
            )
        }
    }

    suspend fun refreshProjects(): Result<Unit> {
        return refreshApi({
            apiProvider.kanbanApi.getAllProjects()
        }, { projects ->
//            println("all projects: $projects")
            database.projectDao().insertAll(projects)
        })
    }

    suspend fun refreshColumns(projectId: Int): Result<Unit> {
        return refreshApi({
            apiProvider.kanbanApi.getColumns(projectId)
        }, { columns ->
//            println("all columns: $columns")
            database.columnDao().insertAll(columns)
        })
    }

    suspend fun refreshTasks(projectId: Int, isArchived: Boolean): Result<Unit> {
        return refreshApi({
            apiProvider.kanbanApi.getAllTasks(projectId, isArchived)
        }, { tasks ->
//            println("all tasks: $tasks")
            database.taskDao().insertAll(tasks)
        })
    }

    suspend fun refreshSubtasks(taskId: Int): Result<Unit> {
        return refreshApi({
            apiProvider.kanbanApi.getAllSubtasks(taskId)
        }, { subtasks ->
//            println("all subtasks: $subtasks")
            database.subtaskDao().insertAll(subtasks)
        })
    }

    suspend fun refreshComments(taskId: Int): Result<Unit> {
        return refreshApi({
            apiProvider.kanbanApi.getAllComments(taskId)
        }, { comments ->
//            println("all comments: $comments")
            database.commentDao().insertAll(comments)
        })
    }

    suspend fun createProject(name: String) {
        val localProject = apiWorkManager.createProject(name)
        database.projectDao().insertOrUpdate(localProject)
    }
}