package com.kanbored.kanbored.network

import com.kanbored.kanbored.model.AuthConfig
import kotlinx.coroutines.flow.StateFlow
import okhttp3.Credentials
import okhttp3.Interceptor
import okhttp3.Response
import javax.inject.Inject
import javax.inject.Named
import javax.inject.Provider

class AuthInterceptorFactory @Inject constructor(
    @param:Named("auth_config") private val configFlow: StateFlow<AuthConfig?>
) : Provider<Interceptor> {

    override fun get(): Interceptor = AuthInterceptor(configFlow)
}

class AuthInterceptor(
    private val configFlow: StateFlow<AuthConfig?>
) : Interceptor {
    override fun intercept(chain: Interceptor.Chain): Response {
        println("auth interceptor")
        val config = configFlow.value ?: return chain.proceed(chain.request())
        println("auth interceptor: $config")
        val credentials: String = Credentials.basic(config.username, config.password)
        val url = config.baseUrl + chain.request().url.encodedPath
        val request = chain.request()
            .newBuilder()
            .url(url)
            .header("Authorization", credentials)
            .build()
        return chain.proceed(request)
    }
}