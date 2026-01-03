package com.kanbored.kanbored.network

import com.kanbored.kanbored.model.KanbanColumn
import com.kanbored.kanbored.model.KanbanComment
import com.kanbored.kanbored.model.KanbanProject
import com.kanbored.kanbored.model.KanbanSubtask
import com.kanbored.kanbored.model.KanbanTask

class MockKanbanApi : KanbanApi {
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

    override suspend fun genericApi(kanbanRequest: KanbanRequest): KanbanResponse<*, KanbanError> {
        return when (kanbanRequest) {
            is KanbanArrayRequest -> handleApiRequest(kanbanRequest.method)
            is KanbanParamsRequest -> handleApiRequest(kanbanRequest.method)
        }
    }

    @Suppress("UNCHECKED_CAST")
    private fun handleApiRequest(method: String): KanbanResponse<*, KanbanError> {
        return when (method) {
            KanbanMethod.CreateProject.name -> {
                KanbanResponse("", 1)
            }

            else -> KanbanResponse("", null, error = "Failed")
        } as KanbanResponse<*, KanbanError>
    }
}