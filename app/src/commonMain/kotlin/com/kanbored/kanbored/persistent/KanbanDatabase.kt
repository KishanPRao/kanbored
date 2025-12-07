package com.kanbored.kanbored.persistent

import androidx.room.Dao
import androidx.room.Database
import androidx.room.Delete
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import androidx.room.RoomDatabase
import androidx.room.Update
import com.kanbored.kanbored.model.KanbanProject
import kotlinx.coroutines.flow.Flow

const val kanbanProjectTableName = "kanban_project"

@Dao
interface KanbanProjectDao {
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertOrUpdate(project: KanbanProject)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertAll(projects: List<KanbanProject>)

    @Update
    suspend fun update(project: KanbanProject)

    @Delete
    suspend fun delete(project: KanbanProject)

    @Query("select * from $kanbanProjectTableName")
    fun getAllProjects(): Flow<List<KanbanProject>>

    @Query("select * from $kanbanProjectTableName")
    suspend fun getAllProjectsSync(): List<KanbanProject>
}

@Database(entities = [KanbanProject::class], version = 1)
abstract class KanbanDatabase : RoomDatabase() {

    abstract fun projectDao(): KanbanProjectDao

    companion object {
        const val DATABASE_NAME = "kanban_database"
    }
}

// TODO: re-enable code when jvm for KMP
//expect fun createKanbanDatabase(context: PlatformContext, databaseName: String): KanbanDatabase