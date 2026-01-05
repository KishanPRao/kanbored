package com.kanbored.kanbored.di

import com.kanbored.kanbored.network.ApiProvider
import com.kanbored.kanbored.network.ConnectivityListener
import com.kanbored.kanbored.network.MockApiProvider
import com.kanbored.kanbored.network.MockConnectivityListener
import dagger.Binds
import dagger.Module
import dagger.hilt.components.SingletonComponent
import dagger.hilt.testing.TestInstallIn
import javax.inject.Singleton

@Suppress("unused")
@Module
@TestInstallIn(components = [SingletonComponent::class], replaces = [NetworkProviderModule::class])
abstract class TestNetworkProviderModule {

    @Binds
    @Singleton
    abstract fun bindConnectivityListener(
        impl: MockConnectivityListener
    ): ConnectivityListener

    @Binds
    @Singleton
    abstract fun bindsApiProvider(
        impl: MockApiProvider
    ): ApiProvider
}