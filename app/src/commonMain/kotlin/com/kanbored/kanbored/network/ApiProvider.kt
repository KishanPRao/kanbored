package com.kanbored.kanbored.network

interface ApiProvider {
    val kanbanApi: KanbanApi

    suspend fun isApiReachable(): Boolean
}