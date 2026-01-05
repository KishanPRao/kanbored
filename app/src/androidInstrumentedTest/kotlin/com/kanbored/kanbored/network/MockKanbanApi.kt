package com.kanbored.kanbored.network

import com.kanbored.kanbored.model.KanbanColumn
import com.kanbored.kanbored.model.KanbanComment
import com.kanbored.kanbored.model.KanbanProject
import com.kanbored.kanbored.model.KanbanSubtask
import com.kanbored.kanbored.model.KanbanTask
import kotlinx.serialization.json.JsonElement
import kotlinx.serialization.json.JsonPrimitive

class MockKanbanApi : KanbanApi {
    private var resultId = 1

    override suspend fun login(kanbanRequest: KanbanRequest): KanbanLoginResponse {
        TODO("Not yet implemented")
    }

    override suspend fun getAllProjects(kanbanRequest: KanbanRequest): KanbanResponse<List<KanbanProject>, KanbanError> {
        TODO("Not yet implemented")
    }

    override suspend fun getColumns(
        projectId: Int,
        kanbanRequest: KanbanRequest
    ): KanbanResponse<List<KanbanColumn>, KanbanError> {
        TODO("Not yet implemented")
    }

    override suspend fun getAllTasks(
        projectId: Int,
        isArchived: Boolean,
        kanbanRequest: KanbanRequest
    ): KanbanResponse<List<KanbanTask>, KanbanError> {
        TODO("Not yet implemented")
    }

    override suspend fun getAllSubtasks(
        taskId: Int,
        kanbanRequest: KanbanRequest
    ): KanbanResponse<List<KanbanSubtask>, KanbanError> {
        TODO("Not yet implemented")
    }

    override suspend fun getAllComments(
        taskId: Int,
        kanbanRequest: KanbanRequest
    ): KanbanResponse<List<KanbanComment>, KanbanError> {
        TODO("Not yet implemented")
    }

    override suspend fun genericApi(kanbanRequest: KanbanRequest): KanbanResponse<JsonElement, KanbanError> {
        return when (kanbanRequest.method) {
            KanbanMethod.CreateProject.methodName,
            KanbanMethod.AddColumn.methodName -> {
                KanbanResponse(jsonrpc, JsonPrimitive(resultId++))
            }

            KanbanMethod.UpdateProject.methodName -> {
                KanbanResponse(jsonrpc, JsonPrimitive(true))
            }

            else -> KanbanResponse(jsonrpc, null, error = KanbanError(0, "API not handled"))
        }
    }

    private val jsonrpc = "2.0"
}