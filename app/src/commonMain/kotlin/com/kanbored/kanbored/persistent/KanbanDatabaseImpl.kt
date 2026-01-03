package com.kanbored.kanbored.persistent

import androidx.room.Database
import androidx.room.RoomDatabase
import androidx.room.TypeConverters
import com.kanbored.kanbored.model.ApiStorage
import com.kanbored.kanbored.model.KanbanColumn
import com.kanbored.kanbored.model.KanbanComment
import com.kanbored.kanbored.model.KanbanProject
import com.kanbored.kanbored.model.KanbanSubtask
import com.kanbored.kanbored.model.KanbanTask
import com.kanbored.kanbored.utils.KanbanMethodConverter
import com.kanbored.kanbored.utils.KanbanParamsConverter

@Database(
    entities = [
        KanbanProject::class,
        KanbanColumn::class,
        KanbanTask::class,
        KanbanSubtask::class,
        KanbanComment::class,
        ApiStorage::class,
    ],
    version = 1
)
@TypeConverters(KanbanParamsConverter::class, KanbanMethodConverter::class)
abstract class KanbanDatabaseImpl : KanbanDatabase, RoomDatabase()
