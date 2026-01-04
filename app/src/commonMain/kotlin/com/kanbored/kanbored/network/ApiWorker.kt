package com.kanbored.kanbored.network

import android.content.Context
import androidx.hilt.work.HiltWorker
import androidx.work.CoroutineWorker
import androidx.work.ListenableWorker
import androidx.work.WorkerParameters
import com.kanbored.kanbored.model.ApiStorage
import com.kanbored.kanbored.persistent.KanbanDatabase
import com.kanbored.kanbored.utils.ApiFailedException
import com.kanbored.kanbored.utils.InvalidResponseException
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
            println("Failed to execute Api Worker: $e")
            Result.failure()
        }
    }

    private suspend fun processApi() {
        var api = database.apiStorageDao().getNextApi()
        println("processApi [${database.apiStorageDao().getAllSync().size}]: $api")
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
        println("processApi: fin!")
    }

    private suspend fun handleResponse(apiStorage: ApiStorage, result: Any) {
        println("handleResponse: $result")
        when (result) {
            is Int -> {
                when (apiStorage.kanbanMethod) {
                    KanbanMethod.CreateProject -> {
                        println("create proj: update id: ${apiStorage.updateId} -> $result")
                        database.projectDao().updateId(apiStorage.updateId, result)
                        database.apiStorageDao().updateProjectId(apiStorage.updateId, result)
                    }

                    KanbanMethod.AddColumn -> {
                        println("add col: update id: ${apiStorage.updateId} -> $result")
                        database.columnDao().updateId(apiStorage.updateId, result)
                        database.apiStorageDao().updateColumnId(apiStorage.updateId, result)
                    }

                    else -> {}
                }
            }

            is Boolean -> {
                if (!result) {
                    throw ApiFailedException("${apiStorage.kanbanMethod.methodName} failed")
                } else {
                    println("Valid!")
                }
            }

            else -> {
                throw InvalidResponseException("Invalid response type: $result, ${result::class}")
            }
        }
    }

    companion object {
        val TAG = ApiWorker::class.simpleName ?: "ApiWorker"
        const val WORK_NAME = "ApiWork"
    }
}