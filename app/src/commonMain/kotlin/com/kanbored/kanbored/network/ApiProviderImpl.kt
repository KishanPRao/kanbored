package com.kanbored.kanbored.network

import com.kanbored.kanbored.model.AuthConfig
import com.kanbored.kanbored.utils.InvalidCredentialsException
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.withContext
import okhttp3.OkHttpClient
import okhttp3.Request
import retrofit2.Retrofit
import javax.inject.Inject
import javax.inject.Named
import javax.inject.Singleton

@Singleton
class ApiProviderImpl @Inject constructor(
    private val retrofitBuilder: Retrofit.Builder,
    private val okHttpClient: OkHttpClient,
    @param:Named("auth_config") private val configFlow: StateFlow<AuthConfig?>
) : ApiProvider {
    @Volatile
    private var _kanbanApi: KanbanApi? = null
    override val kanbanApi: KanbanApi
        get() {
            return _kanbanApi ?: synchronized(this) {
                val api = retrofitBuilder
                    .build()
                    .create(KanbanApi::class.java)
                _kanbanApi = api
                api
            }
        }


    override suspend fun isApiReachable(): Boolean {
        val baseUrl = configFlow.value?.baseUrl ?: throw InvalidCredentialsException()
        return withContext(Dispatchers.IO) {
            try {
                val request = Request.Builder()
                    .url(baseUrl)
                    .head()
                    .build()

                val response = okHttpClient.newCall(request).execute()
                response.isSuccessful
            } catch (_: Exception) {
                false
            }
        }
    }
}