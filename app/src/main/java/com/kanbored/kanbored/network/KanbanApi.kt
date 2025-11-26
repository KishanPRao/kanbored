package com.kanbored.kanbored.network

import com.kanbored.kanbored.utils.endPoint
import retrofit2.http.Body
import retrofit2.http.POST

interface KanbanApi {
    @POST(endPoint)
    suspend fun login(@Body kanbanLoginRequest: KanbanLoginRequest): KanbanLoginResponse
}