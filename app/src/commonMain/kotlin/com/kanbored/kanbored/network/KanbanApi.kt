package com.kanbored.kanbored.network

import com.kanbored.kanbored.model.KanbanProject
import com.kanbored.kanbored.utils.endPoint
import retrofit2.http.Body
import retrofit2.http.POST

interface KanbanApi {
    @POST(endPoint)
    suspend fun login(
        @Body kanbanRequest: KanbanRequest = createKanbanRequest(KanbanMethod.GetMe)
    ): KanbanLoginResponse

    @POST(endPoint)
    suspend fun getAllProjects(
        @Body kanbanRequest: KanbanRequest = createKanbanRequest(KanbanMethod.GetAllProjects)
    ): KanbanResponse<List<KanbanProject>, KanbanLoginError>
}

private fun createKanbanRequest(kanbanMethod: KanbanMethod): KanbanRequest {
    return KanbanRequest(
        method = kanbanMethod.name,
        id = kanbanMethod.id,
    )
}