package com.kanbored.kanbored.network

import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class MocApiProvider @Inject constructor() : ApiProvider {
    override val kanbanApi: KanbanApi = MockKanbanApi()
    override suspend fun isApiReachable(): Boolean = true
}