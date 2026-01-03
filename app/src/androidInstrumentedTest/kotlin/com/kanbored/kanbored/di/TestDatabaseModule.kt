package com.kanbored.kanbored.di

import android.content.Context
import com.kanbored.kanbored.persistent.MockDatabase
import com.kanbored.kanbored.persistent.KanbanDatabase
import com.kanbored.kanbored.persistent.KanbanProjectDao
import dagger.Module
import dagger.Provides
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import dagger.hilt.testing.TestInstallIn
import javax.inject.Singleton

@Module
@TestInstallIn(
    components = [SingletonComponent::class],
    replaces = [DatabaseModule::class]
)
object TestDatabaseModule {
    @Provides
    @Singleton
    fun provideDatabase(@ApplicationContext context: Context): KanbanDatabase =
        MockDatabase()

    @Provides
    @Singleton
    fun provideProjectDao(db: KanbanDatabase): KanbanProjectDao = db.projectDao()
}