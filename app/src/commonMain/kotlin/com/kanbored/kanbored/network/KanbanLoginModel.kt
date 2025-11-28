package com.kanbored.kanbored.network

import kotlinx.serialization.Serializable

@Serializable
data class KanbanRequest(val method: String, val id: Int, val jsonrpc: String = "2.0")

@Serializable
data class KanbanLoginResponse(
    val jsonrpc: String,
    val result: KanbanLoginUserInfo? = null,
    val error: KanbanLoginError? = null,
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
data class KanbanLoginError(val code: Int, val message: String)