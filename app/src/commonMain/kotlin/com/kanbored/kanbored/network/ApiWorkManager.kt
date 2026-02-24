package com.kanbored.kanbored.network

import android.content.Context
import androidx.work.ExistingWorkPolicy
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.WorkManager
import co.touchlab.kermit.Logger
import com.kanbored.kanbored.model.KanbanColumn
import com.kanbored.kanbored.model.KanbanCommandOperations
import com.kanbored.kanbored.model.KanbanProject
import com.kanbored.kanbored.model.KanbanTask
import com.kanbored.kanbored.persistent.KanbanDatabase
import com.kanbored.kanbored.utils.ModelUtils.createApiStorage
import com.kanbored.kanbored.utils.createKanbanColumn
import com.kanbored.kanbored.utils.createKanbanProject
import com.kanbored.kanbored.utils.createKanbanTask
import dagger.hilt.android.qualifiers.ApplicationContext
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.filter
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.withContext
import javax.inject.Inject
import javax.inject.Singleton

/**
 * All creation tasks need to go through this
 * Maybe also all API retrieval tasks should go through this: complete all write operations, then allow retrieving
 */
@Singleton
class ApiWorkManager @Inject constructor(
    connectivityListener: ConnectivityListener,
    private val database: KanbanDatabase,
    @param:ApplicationContext private val context: Context,
) : KanbanCommandOperations {
    private val workManager by lazy {
        WorkManager.getInstance(context)
    }
    private val coroutineCtx = Dispatchers.IO
    private val scope = CoroutineScope(coroutineCtx)
    private val isApiReachable = connectivityListener.isApiReachable

    init {
        isApiReachable.filter { it }
            .onEach {
                println("api work mgr start worker")
                startWorkerIfNotStarted()
            }
            .launchIn(scope)
    }

    /******************* MARK: CREATE ******************/

    override suspend fun createProject(name: String): KanbanProject = withContext(coroutineCtx) {
        val localId = database.apiStorageDao().getNextId()
        val local = createKanbanProject(name).copy(id = localId)
        Logger.d("createProject: $local")
        database.projectDao().upsert(local)
        val apiStorage = createApiStorage(
            KanbanMethod.CreateProject, KanbanParams(name = name), localId
        )
        database.apiStorageDao().upsert(apiStorage)
        startWorkerIfNotStarted()
        local
    }

    override suspend fun createColumn(projectId: Int, name: String): KanbanColumn =
        withContext(coroutineCtx) {
            val localId = database.apiStorageDao().getNextId()
            val position = (database.columnDao().getLargestPositionSync(projectId) ?: 0) + 1
            val local = createKanbanColumn(name)
                .copy(id = localId, projectId = projectId, position = position)
            Logger.d("createColumn: $local")
            database.columnDao().upsert(local)
            val apiStorage = createApiStorage(
                KanbanMethod.AddColumn,
                KanbanParams(projectId = projectId, title = name),
                updateId = localId
            )
            database.apiStorageDao().upsert(apiStorage)
            startWorkerIfNotStarted()
            local
        }

    override suspend fun createTask(projectId: Int, columnId: Int, name: String): KanbanTask =
        withContext(coroutineCtx) {
            val localId = database.apiStorageDao().getNextId()
            val position = (database.taskDao().getLargestPositionSync(projectId, columnId) ?: 0) + 1
            val local = createKanbanTask(name)
                .copy(id = localId, projectId = projectId, columnId = columnId, position = position)
            Logger.d("createTask: $local")
            database.taskDao().upsert(local)
            val apiStorage = createApiStorage(
                KanbanMethod.CreateTask,
                KanbanParams(projectId = projectId, columnId = columnId, title = name),
                updateId = localId
            )
            database.apiStorageDao().upsert(apiStorage)
            startWorkerIfNotStarted()
            local
        }

    /******************* MARK: UPDATE ******************/

    override suspend fun updateProject(project: KanbanProject) = withContext(coroutineCtx) {
        Logger.d("updateProject: $project")
        database.projectDao().upsert(project)
        val apiStorage = createApiStorage(
            KanbanMethod.UpdateProject,
            // TODO: might be a better idea to send the entire object for updates (everything except "project_id")
            KanbanParams(projectId = project.id, name = project.name),
            updateId = project.id
        )
        database.apiStorageDao().upsert(apiStorage)
        startWorkerIfNotStarted()
    }

    override suspend fun updateColumn(column: KanbanColumn) {
        TODO("Not yet implemented")
    }

    override suspend fun updateTask(task: KanbanTask) = withContext(coroutineCtx) {
        Logger.d("updateTask: $task")
        database.taskDao().upsert(task)
        val apiStorage = createApiStorage(
            KanbanMethod.UpdateTask,
            KanbanParams(id = task.id, title = task.title),
            updateId = task.id
        )
        database.apiStorageDao().upsert(apiStorage)
        startWorkerIfNotStarted()
    }

    /******************* MARK: ENABLE/DISABLE ******************/

    override suspend fun enableProject(project: KanbanProject) = withContext(coroutineCtx) {
        Logger.d("enableProject: $project")
        database.projectDao().upsert(project.copy(isActive = true))
        val apiStorage = createApiStorage(
            KanbanMethod.EnableProject,
            KanbanParams(projectId = project.id),
            updateId = project.id
        )
        database.apiStorageDao().upsert(apiStorage)
        startWorkerIfNotStarted()
    }

    override suspend fun disableProject(project: KanbanProject) = withContext(coroutineCtx) {
        Logger.d("disableProject: $project")
        database.projectDao().upsert(project.copy(isActive = false))
        val apiStorage = createApiStorage(
            KanbanMethod.DisableProject,
            KanbanParams(projectId = project.id),
            updateId = project.id
        )
        database.apiStorageDao().upsert(apiStorage)
        startWorkerIfNotStarted()
    }

    /******************* MARK: DELETE ******************/

    override suspend fun deleteProject(project: KanbanProject) = withContext(coroutineCtx) {
        database.projectDao().delete(project)
        val apiStorage = createApiStorage(
            KanbanMethod.RemoveProject,
            KanbanParams(projectId = project.id),
            project.id
        )
        database.apiStorageDao().upsert(apiStorage)
        startWorkerIfNotStarted()
    }

    override suspend fun deleteTask(task: KanbanTask) = withContext(coroutineCtx) {
        database.taskDao().delete(task)
        val apiStorage = createApiStorage(
            KanbanMethod.RemoveTask,
            KanbanParams(taskId = task.id),
            task.id
        )
        database.apiStorageDao().upsert(apiStorage)
        startWorkerIfNotStarted()
    }

    /******************* MARK: UTILS ******************/

    private fun startWorkerIfNotStarted() {
        if (!isApiReachable.value) {
            println("Cannot start worker, no network")
            return
        }
        val workRequest = OneTimeWorkRequestBuilder<ApiWorker>()
            .addTag(ApiWorker.TAG)
            .build()
        workManager.enqueueUniqueWork(
            ApiWorker.WORK_NAME,
            ExistingWorkPolicy.KEEP,
            workRequest
        )
    }
}