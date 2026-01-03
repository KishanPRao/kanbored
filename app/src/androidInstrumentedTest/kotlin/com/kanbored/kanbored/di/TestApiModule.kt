package com.kanbored.kanbored.di

import com.kanbored.kanbored.network.ApiProvider
import com.kanbored.kanbored.network.MocApiProvider
import dagger.Binds
import dagger.Module
import dagger.hilt.components.SingletonComponent
import dagger.hilt.testing.TestInstallIn
import javax.inject.Singleton

@Module
@TestInstallIn(components = [SingletonComponent::class], replaces = [ApiModule::class])
abstract class TestApiModule {
    @Binds
    @Singleton
    abstract fun bindsApiProvider(
        impl: MocApiProvider
    ): ApiProvider
}