package com.kanbored.kanbored.model

data class KanbanUserSession(
    val userId: Int,
    val userName: String,
    val password: String,
    val hostUrl: String,
    val appRole: String,
    val authenticated: Boolean,
)