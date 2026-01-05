package com.kanbored.kanbored.network

import android.content.Context
import androidx.work.ExistingWorkPolicy
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.WorkManager
import com.kanbored.kanbored.model.KanbanColumn
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
) {
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

    suspend fun createProject(name: String): KanbanProject = withContext(coroutineCtx) {
        val localId = database.apiStorageDao().getNextId()
        val local = createKanbanProject(name).copy(id = localId)
        database.projectDao().insertOrUpdate(local)
        val apiStorage =
            createApiStorage(KanbanMethod.CreateProject, KanbanParams(name = name), localId)
        database.apiStorageDao().insertOrUpdate(apiStorage)
        startWorkerIfNotStarted()
        local
    }

    suspend fun createColumn(projectId: Int, name: String): KanbanColumn =
        withContext(coroutineCtx) {
            val localId = database.apiStorageDao().getNextId()
            val local = createKanbanColumn(name).copy(id = localId, projectId = projectId)
            database.columnDao().insertOrUpdate(local)
            val apiStorage = createApiStorage(
                KanbanMethod.AddColumn,
                KanbanParams(projectId = projectId, title = name),
                localId
            )
            database.apiStorageDao().insertOrUpdate(apiStorage)
            startWorkerIfNotStarted()
            local
        }

    suspend fun createTask(projectId: Int, columnId: Int, name: String): KanbanTask =
        withContext(coroutineCtx) {
            val localId = database.apiStorageDao().getNextId()
            val local = createKanbanTask(name)
                .copy(id = localId, projectId = projectId, columnId = columnId)
            database.taskDao().insertOrUpdate(local)
            val apiStorage = createApiStorage(
                KanbanMethod.CreateTask,
                KanbanParams(projectId = projectId, columnId = columnId, title = name),
                localId
            )
            database.apiStorageDao().insertOrUpdate(apiStorage)
            startWorkerIfNotStarted()
            local
        }

    /******************* MARK: UPDATE ******************/

    suspend fun updateProject(project: KanbanProject) = withContext(coroutineCtx) {
        database.projectDao().insertOrUpdate(project)
        val apiStorage = createApiStorage(
            KanbanMethod.UpdateProject,
            // TODO: might be a better idea to send the entire object for updates (everything except "project_id")
            KanbanParams(projectId = project.id, name = project.name),
            project.id
        )
        database.apiStorageDao().insertOrUpdate(apiStorage)
        startWorkerIfNotStarted()
    }

    /******************* MARK: DELETE ******************/

    suspend fun deleteProject(project: KanbanProject) = withContext(coroutineCtx) {
        database.projectDao().delete(project)
        val apiStorage = createApiStorage(
            KanbanMethod.RemoveProject,
            KanbanParams(projectId = project.id),
            project.id
        )
        database.apiStorageDao().insertOrUpdate(apiStorage)
        startWorkerIfNotStarted()
    }

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