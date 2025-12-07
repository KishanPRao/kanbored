package com.kanbored.kanbored.network

import retrofit2.Retrofit
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class ApiProvider @Inject constructor(
    private val retrofitBuilder: Retrofit.Builder,
) {
    @Volatile
    private var kanbanApi: KanbanApi? = null

    fun getKanbanApi(): KanbanApi {
        return kanbanApi ?: synchronized(this) {
            val api = retrofitBuilder
                .build()
                .create(KanbanApi::class.java)
            kanbanApi = api
            api
        }
    }
}