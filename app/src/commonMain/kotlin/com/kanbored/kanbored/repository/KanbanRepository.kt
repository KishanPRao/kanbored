package com.kanbored.kanbored.repository

import co.touchlab.kermit.Logger
import com.kanbored.kanbored.model.KanbanColumn
import com.kanbored.kanbored.model.KanbanCommandOperations
import com.kanbored.kanbored.model.KanbanComment
import com.kanbored.kanbored.model.KanbanProject
import com.kanbored.kanbored.model.KanbanQueryOperations
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
) : KanbanQueryOperations, KanbanCommandOperations {
    override fun getAllProjects(): Flow<List<KanbanProject>> = database.projectDao().getAll()

    override fun getProject(id: Int): Flow<KanbanProject?> =
        database.projectDao().getSingle(id)

    override fun getColumns(projectId: Int, isArchived: Boolean): Flow<List<KanbanColumn>> =
        database.columnDao().get(projectId)

    override fun getTasks(
        projectId: Int,
        columnId: Int,
        isArchived: Boolean
    ): Flow<List<KanbanTask>> =
        database.taskDao().get(projectId, columnId, isActive = !isArchived)

    override fun getTask(projectId: Int, columnId: Int, taskId: Int): Flow<KanbanTask?> =
        database.taskDao().getSingle(projectId, columnId, taskId)

    override fun getSubtasks(taskId: Int): Flow<List<KanbanSubtask>> =
        database.subtaskDao().get(taskId)

    override fun getComments(taskId: Int): Flow<List<KanbanComment>> =
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

    override suspend fun refreshProjects(): Result<Unit> {
        Logger.v("refreshProjects")
        return refreshApi({
            apiProvider.kanbanApi.getAllProjects()
        }, { projects ->
//            Logger.d("all projects: $projects")
            database.projectDao().upsertAll(projects)
        })
    }

    override suspend fun refreshColumns(projectId: Int): Result<Unit> {
        Logger.v("refreshColumns: $projectId")
        return refreshApi({
            apiProvider.kanbanApi.getColumns(projectId)
        }, { columns ->
//            Logger.d("all columns: $columns")
            database.columnDao().upsertAll(columns)
        })
    }

    override suspend fun refreshTasks(projectId: Int, isArchived: Boolean): Result<Unit> {
        Logger.v("refreshTasks: $projectId: $isArchived")
        return refreshApi({
            apiProvider.kanbanApi.getAllTasks(projectId, isArchived)
        }, { tasks ->
            Logger.v("all tasks: $tasks")
            database.taskDao().upsertAll(tasks)
        })
    }

    override suspend fun refreshSubtasks(taskId: Int): Result<Unit> {
        Logger.v("refreshSubtasks: $taskId")
        return refreshApi({
            apiProvider.kanbanApi.getAllSubtasks(taskId)
        }, { subtasks ->
//            Logger.d("all subtasks: $subtasks")
            database.subtaskDao().upsertAll(subtasks)
        })
    }

    override suspend fun refreshComments(taskId: Int): Result<Unit> {
        Logger.v("refreshComments: $taskId")
        return refreshApi({
            apiProvider.kanbanApi.getAllComments(taskId)
        }, { comments ->
//            Logger.d("all comments: $comments")
            database.commentDao().upsertAll(comments)
        })
    }

    override suspend fun createProject(name: String) = apiWorkManager.createProject(name)

    override suspend fun createColumn(projectId: Int, name: String) =
        apiWorkManager.createColumn(projectId, name)

    override suspend fun createTask(projectId: Int, columnId: Int, name: String) =
        apiWorkManager.createTask(projectId, columnId, name)

    override suspend fun updateProject(project: KanbanProject) =
        apiWorkManager.updateProject(project)

    override suspend fun updateColumn(column: KanbanColumn) =
        apiWorkManager.updateColumn(column)

    override suspend fun updateTask(task: KanbanTask) {
        apiWorkManager.updateTask(task)
    }

    override suspend fun enableProject(project: KanbanProject) =
        apiWorkManager.enableProject(project)

    override suspend fun disableProject(project: KanbanProject) =
        apiWorkManager.disableProject(project)

    override suspend fun deleteProject(project: KanbanProject) =
        apiWorkManager.deleteProject(project)

    override suspend fun deleteTask(task: KanbanTask) = apiWorkManager.deleteTask(task)
}