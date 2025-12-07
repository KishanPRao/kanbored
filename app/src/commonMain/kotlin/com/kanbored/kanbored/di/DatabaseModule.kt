package com.kanbored.kanbored.di

import android.content.Context
import androidx.room.Room
import com.kanbored.kanbored.persistent.KanbanDatabase
import com.kanbored.kanbored.persistent.KanbanProjectDao
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
object DatabaseModule {
    @Provides
    @Singleton
    fun provideDatabase(@ApplicationContext context: Context): KanbanDatabase =
        Room.databaseBuilder(context, KanbanDatabase::class.java, KanbanDatabase.DATABASE_NAME)
            .build()

    @Provides
    @Singleton
    fun provideProjectDao(db: KanbanDatabase): KanbanProjectDao = db.projectDao()
}