package com.kanbored.kanbored.network

import kotlinx.serialization.Serializable

@Serializable
data class KanbanRequest(
    val method: String,
    val id: Int,
    val jsonrpc: String = "2.0",
    val params: KanbanParams?
)

@Serializable
data class KanbanLoginResponse(
    val jsonrpc: String,
    val result: KanbanLoginUserInfo? = null,
    val error: KanbanError? = null,
    val id: Int? = null,
)

@Serializable
data class KanbanResponse<Result, Error>(
    val jsonrpc: String,
    val result: Result? = null,
    val error: Error? = null,
    val id: Int? = null,
)

@Serializable
data class KanbanLoginUserInfo(val id: Int, val role: String)

@Serializable
data class KanbanError(val code: Int, val message: String)