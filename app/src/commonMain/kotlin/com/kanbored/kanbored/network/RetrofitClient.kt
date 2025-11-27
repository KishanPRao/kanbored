package com.kanbored.kanbored.network

import kotlinx.serialization.json.Json
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.converter.kotlinx.serialization.asConverterFactory


object RetrofitClient {
    fun createApi(userName: String, password: String, hostUrl: String): KanbanApi {
        val json = Json {
            ignoreUnknownKeys = true
            encodeDefaults = true
        }
        val loggingInterceptor = HttpLoggingInterceptor().apply {
            level = HttpLoggingInterceptor.Level.BODY
        }
        val client = OkHttpClient.Builder()
            .addInterceptor(BasicAuthInterceptor(userName, password))
            .addInterceptor(loggingInterceptor)
            .build()
        return Retrofit
            .Builder()
            .baseUrl(hostUrl)
            .client(client)
            .addConverterFactory(json.asConverterFactory("application/json".toMediaType()))
            .build()
            .create(KanbanApi::class.java)
    }
}