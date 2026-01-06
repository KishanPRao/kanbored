package com.kanbored.kanbored.repository

import co.touchlab.kermit.Logger
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
import kotlinx.coroutines.flow.Flow
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class KanbanRepository @Inject constructor(
    // TODO: db or all DAOs?
    private val database: KanbanDatabase,
    private val apiProvider: ApiProvider,
    private val apiWorkManager: ApiWorkManager,
) {
    fun getAllProjects(): Flow<List<KanbanProject>> = database.projectDao().getAll()

    fun getProject(id: Int): Flow<KanbanProject?> =
        database.projectDao().getSingle(id)

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
            e.printStackTrace()
            Logger.e("refreshApi error: ${e.message}")
            return Result.Error(
                e.message?.let { PresentableText.DynamicString(it) }
                    ?: PresentableText.DynamicResource(Res.string.error_unknown)
            )
        }
    }

    suspend fun refreshProjects(): Result<Unit> {
        Logger.d("refreshProjects")
        return refreshApi({
            apiProvider.kanbanApi.getAllProjects()
        }, { projects ->
//            Logger.d("all projects: $projects")
            database.projectDao().upsertAll(projects)
        })
    }

    suspend fun refreshColumns(projectId: Int): Result<Unit> {
        Logger.d("refreshColumns: $projectId")
        return refreshApi({
            apiProvider.kanbanApi.getColumns(projectId)
        }, { columns ->
//            Logger.d("all columns: $columns")
            database.columnDao().upsertAll(columns)
        })
    }

    suspend fun refreshTasks(projectId: Int, isArchived: Boolean): Result<Unit> {
        Logger.d("refreshTasks: $projectId: $isArchived")
        return refreshApi({
            apiProvider.kanbanApi.getAllTasks(projectId, isArchived)
        }, { tasks ->
//            Logger.d("all tasks: $tasks")
            database.taskDao().upsertAll(tasks)
        })
    }

    suspend fun refreshSubtasks(taskId: Int): Result<Unit> {
        Logger.d("refreshSubtasks")
        return refreshApi({
            apiProvider.kanbanApi.getAllSubtasks(taskId)
        }, { subtasks ->
//            Logger.d("all subtasks: $subtasks")
            database.subtaskDao().upsertAll(subtasks)
        })
    }

    suspend fun refreshComments(taskId: Int): Result<Unit> {
        Logger.d("refreshComments")
        return refreshApi({
            apiProvider.kanbanApi.getAllComments(taskId)
        }, { comments ->
//            Logger.d("all comments: $comments")
            database.commentDao().upsertAll(comments)
        })
    }

    suspend fun createProject(name: String) = apiWorkManager.createProject(name)

    suspend fun createColumn(projectId: Int, name: String) =
        apiWorkManager.createColumn(projectId, name)

    suspend fun createTask(projectId: Int, columnId: Int, name: String) =
        apiWorkManager.createTask(projectId, columnId, name)

    suspend fun updateProject(project: KanbanProject) = apiWorkManager.updateProject(project)

    suspend fun deleteProject(project: KanbanProject) = apiWorkManager.deleteProject(project)
}