package com.kanbored.kanbored.network

import android.content.Context
import androidx.hilt.work.HiltWorker
import androidx.work.CoroutineWorker
import androidx.work.ListenableWorker
import androidx.work.WorkerParameters
import co.touchlab.kermit.Logger
import com.kanbored.kanbored.model.ApiStorage
import com.kanbored.kanbored.persistent.KanbanDatabase
import com.kanbored.kanbored.utils.ApiFailedException
import com.kanbored.kanbored.utils.InvalidResponseException
import dagger.assisted.Assisted
import dagger.assisted.AssistedInject
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import kotlinx.serialization.json.JsonElement
import kotlinx.serialization.json.JsonNull
import kotlinx.serialization.json.JsonPrimitive
import kotlinx.serialization.json.booleanOrNull
import kotlinx.serialization.json.doubleOrNull
import kotlinx.serialization.json.intOrNull
import kotlinx.serialization.json.longOrNull

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
            e.printStackTrace()
            println("Failed to execute Api Worker: $e")
            Result.failure()
        }
    }

    suspend fun genericApi(apiStorage: ApiStorage) = apiProvider.kanbanApi.genericApi(
        createKanbanRequest(
            apiStorage.kanbanMethod,
            apiStorage.kanbanParams
        )
    )

    private suspend fun processApi() {
        var apiStorage = database.apiStorageDao().getNextApi()
        println("processApi [${database.apiStorageDao().getAllSync().size}]: $apiStorage")
        while (apiStorage != null) {
            Logger.d("genericApi: ${apiStorage.kanbanMethod.methodName}, ${apiStorage.kanbanParams}; ${apiStorage.updateId}")
            val response = genericApi(apiStorage)
            if (response.result != null) {
                val result = response.result.toPrimitiveOrNull()
                handleResponse(apiStorage, result)
            } else if (response.error != null) {
                throw ApiFailedException(response.error.message)
            } else {
                throw ApiFailedException("Unknown failure")
            }
            database.apiStorageDao().delete(apiStorage)
            apiStorage = database.apiStorageDao().getNextApi()
        }
        println("processApi: fin!")
    }

    private suspend fun handleResponse(apiStorage: ApiStorage, result: Any?) {
        println("handleResponse: $result")
        when (result) {
            is Int -> {
                when (apiStorage.kanbanMethod.methodName) {
                    KanbanMethod.CreateProject.methodName, KanbanMethod.AddColumn.methodName, KanbanMethod.CreateTask.methodName -> {
                        database.apiStorageDao().updateUpdateId(apiStorage.updateId, result)
                    }
                }
                when (apiStorage.kanbanMethod.methodName) {
                    KanbanMethod.CreateProject.methodName -> {
                        Logger.i("create proj: update id: ${apiStorage.updateId} -> $result")
                        database.projectDao().updateId(apiStorage.updateId, result)
                        database.apiStorageDao().updateProjectId(apiStorage.updateId, result)
                    }

                    KanbanMethod.AddColumn.methodName -> {
                        Logger.i("add col: update id: ${apiStorage.updateId} -> $result")
                        database.columnDao().updateId(apiStorage.updateId, result)
                        database.apiStorageDao().updateColumnId(apiStorage.updateId, result)
                    }

                    KanbanMethod.CreateTask.methodName -> {
                        Logger.i("add task: update id: ${apiStorage.updateId} -> $result")
                        database.taskDao().updateId(apiStorage.updateId, result)
                    }

                    else -> {
                        InvalidResponseException("Unhandled kanban method: ${apiStorage.kanbanMethod}, ${apiStorage.kanbanMethod.methodName}, with result: $result")
                    }
                }
            }

            is Boolean -> {
                if (!result) {
                    throw ApiFailedException("${apiStorage.kanbanMethod.methodName} failed")
                } else {
                    Logger.i("Successful api request!")
                }
            }

            else -> {
                throw InvalidResponseException("Invalid response type: $result, ${result?.let { it::class }}")
            }
        }
    }

    companion object {
        val TAG = ApiWorker::class.simpleName ?: "ApiWorker"
        const val WORK_NAME = "ApiWork"
    }
}

fun JsonElement.toPrimitiveOrNull(): Any? = when (this) {
    is JsonPrimitive -> {
        booleanOrNull ?: intOrNull ?: longOrNull ?: doubleOrNull ?: content
    }

    JsonNull -> null
    else -> null
}