package com.kanbored.kanbored.di

import com.kanbored.kanbored.network.ApiProvider
import com.kanbored.kanbored.network.ApiProviderImpl
import dagger.Binds
import dagger.Module
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
abstract class ApiModule {

    @Binds
    @Singleton
    abstract fun bindApiProvider(
        impl: ApiProviderImpl
    ): ApiProvider
}