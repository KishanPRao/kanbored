package com.kanbored.kanbored.persistent

import androidx.room.Room
import androidx.sqlite.driver.bundled.BundledSQLiteDriver
import com.kanbored.kanbored.utils.PlatformContext
import kotlinx.coroutines.Dispatchers
import java.io.File

actual fun createKanbanDatabase(context: PlatformContext, databaseName: String): KanbanDatabase {
    val dbFile = File(System.getProperty("java.io.tmpdir"), databaseName)
    return Room.databaseBuilder<KanbanDatabase>(dbFile.absolutePath)
        .setDriver(BundledSQLiteDriver())
        .setQueryCoroutineContext(Dispatchers.IO)
        .build()
}