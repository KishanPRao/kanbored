package com.kanbored.kanbored.di

import com.kanbored.kanbored.network.ApiProvider
import com.kanbored.kanbored.network.ApiProviderImpl
import com.kanbored.kanbored.network.ConnectivityListener
import com.kanbored.kanbored.network.ConnectivityListenerImpl
import dagger.Binds
import dagger.Module
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
abstract class NetworkProviderModule {

    @Binds
    @Singleton
    abstract fun bindConnectivityListener(
        impl: ConnectivityListenerImpl
    ): ConnectivityListener

    @Binds
    @Singleton
    abstract fun bindApiProvider(
        impl: ApiProviderImpl
    ): ApiProvider
}