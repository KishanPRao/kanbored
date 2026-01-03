package com.kanbored.kanbored.network

import android.content.Context
import androidx.hilt.work.HiltWorker
import androidx.work.CoroutineWorker
import androidx.work.ListenableWorker
import androidx.work.WorkerParameters
import com.kanbored.kanbored.model.ApiStorage
import com.kanbored.kanbored.persistent.KanbanDatabase
import com.kanbored.kanbored.utils.ApiFailedException
import dagger.assisted.Assisted
import dagger.assisted.AssistedInject
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

@HiltWorker
class ApiWorker @AssistedInject constructor(
    @Assisted context: Context,
    @Assisted params: WorkerParameters,
    private val apiProvider: ApiProvider,
    private val database: KanbanDatabase,
) : CoroutineWorker(context, params) {
    override suspend fun doWork(): ListenableWorker.Result = withContext(Dispatchers.IO) {
        try {
            println("doWork")
            processApi()
            Result.success()
        } catch (e: Exception) {
            print("Failed to execute Api Worker: $e")
            Result.retry()
        }
    }

    private suspend fun processApi() {
        var api = database.apiStorageDao().getNextApi()
        println("processApi: $api")
        while (api != null) {
            val response = apiProvider.kanbanApi.genericApi(
                createKanbanRequest(
                    api.kanbanMethod,
                    api.kanbanParams
                )
            )
            if (response.result != null) {
                handleResponse(api, response.result)
            } else if (response.error != null) {
                throw ApiFailedException(response.error.message)
            } else {
                throw ApiFailedException("Unknown failure")
            }
            database.apiStorageDao().delete(api)
            api = database.apiStorageDao().getNextApi()
        }
    }

    private fun handleResponse(apiStorage: ApiStorage, result: Any) {
        println("handleResponse")
        // Update internal id: find out if project/col/task.. type, write query that checks type, then parameter, if not null
        // All creation APIs result in int TODO: bool too??
        if (result is Int) {
            when (apiStorage.kanbanMethod) {
                KanbanMethod.CreateProject -> {

                }

                else -> {

                }
            }
        }
    }

    companion object {
        val TAG = ApiWorker::class.simpleName ?: "ApiWorker"
        const val WORK_NAME = "ApiWork"
    }
}