package com.kanbored.kanbored.network

import android.content.Context
import androidx.work.ExistingWorkPolicy
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.WorkManager
import com.kanbored.kanbored.model.ApiStorage
import com.kanbored.kanbored.model.KanbanProject
import com.kanbored.kanbored.persistent.KanbanDatabase
import com.kanbored.kanbored.utils.createKanbanProject
import dagger.hilt.android.qualifiers.ApplicationContext
import javax.inject.Inject
import javax.inject.Singleton

/**
 * All creation tasks need to go through this
 * Maybe also all API retrieval tasks should go through this: complete all write operations, then allow retrieving
 */
@Singleton
class ApiWorkManager @Inject constructor(
    private val database: KanbanDatabase,
    @param:ApplicationContext private val context: Context,
) {
    private val workManager by lazy {
        WorkManager.getInstance(context)
    }

    suspend fun createProject(name: String): KanbanProject {
        val localId = database.apiStorageDao().getNextId()
        val apiStorage = ApiStorage(
            KanbanMethod.CreateProject, KanbanParams(name = name), localId,
        )
        database.apiStorageDao().insertOrUpdate(apiStorage)
        startWorkerIfNotStarted()
        return createKanbanProject(name).copy(id = localId)
    }

    private fun startWorkerIfNotStarted() {
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