package com.kanbored.kanbored.di

import com.kanbored.kanbored.model.AuthConfig
import com.kanbored.kanbored.network.AuthInterceptorFactory
import com.kanbored.kanbored.network.createJson
import com.kanbored.kanbored.repository.ConfigRepository
import com.kanbored.kanbored.utils.BuildConfiguration
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.flow.StateFlow
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.converter.kotlinx.serialization.asConverterFactory
import javax.inject.Named
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
object NetworkModule {
    @Provides
    @Singleton
    fun provideOkHttpClient(
        interceptorFactory: AuthInterceptorFactory,
        loggingInterceptor: HttpLoggingInterceptor?
    ): OkHttpClient = OkHttpClient.Builder()
        .addInterceptor(interceptorFactory.get())
        .apply { loggingInterceptor?.let { this.addInterceptor(it) } }
        .build()

    @Provides
    @Singleton
    fun provideRetrofitBuilder(okHttpClient: OkHttpClient): Retrofit.Builder {
        val json = createJson()
        return Retrofit.Builder()
            .baseUrl("https://example.com")    // NOTE: This will be replaced by the interceptor
            .client(okHttpClient)
            .addConverterFactory(json.asConverterFactory("application/json".toMediaType()))
    }

    @Provides
    @Singleton
    fun providesHttpLoggingInterceptor(): HttpLoggingInterceptor? {
        return if (BuildConfiguration.isDebug) {
            HttpLoggingInterceptor().apply {
                level = HttpLoggingInterceptor.Level.BODY
            }
        } else {
            null
        }
    }

    @Provides
    @Singleton
    @Named("auth_config")
    fun provideConfigFlow(configRepo: ConfigRepository): StateFlow<AuthConfig?> = configRepo.config
}
