package com.kanbored.kanbored.persistent

import androidx.room.Dao
import androidx.room.Database
import androidx.room.Delete
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import androidx.room.RoomDatabase
import androidx.room.Update
import com.kanbored.kanbored.model.KanbanColumn
import com.kanbored.kanbored.model.KanbanProject
import com.kanbored.kanbored.model.KanbanTask
import kotlinx.coroutines.flow.Flow

const val kanbanProjectTableName = "kanban_project"
const val kanbanColumnTableName = "kanban_column"
const val kanbanTaskTableName = "kanban_task"

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

@Dao
interface KanbanColumnDao {
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertOrUpdate(column: KanbanColumn)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertAll(columns: List<KanbanColumn>)

    @Update
    suspend fun update(column: KanbanColumn)

    @Delete
    suspend fun delete(column: KanbanColumn)

    @Query("select * from $kanbanColumnTableName where projectId == :projectId")
    fun getColumns(projectId: Int): Flow<List<KanbanColumn>>

    @Query("select * from $kanbanColumnTableName")
    fun getAllColumns(): Flow<List<KanbanColumn>>

    @Query("select * from $kanbanColumnTableName")
    suspend fun getAllColumnsSync(): List<KanbanColumn>
}

@Dao
interface KanbanTaskDao {
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertOrUpdate(task: KanbanTask)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertAll(tasks: List<KanbanTask>)

    @Update
    suspend fun update(task: KanbanTask)

    @Delete
    suspend fun delete(task: KanbanTask)

    @Query("select * from $kanbanTaskTableName where columnId == :columnId and projectId == :projectId")
    fun getTasks(projectId: Int, columnId: Int): Flow<List<KanbanTask>>

    @Query("select * from $kanbanTaskTableName where columnId == :columnId and projectId == :projectId and id == :taskId")
    fun getTaskSync(projectId: Int, columnId: Int, taskId: Int): Flow<KanbanTask?>
}

@Database(entities = [KanbanProject::class, KanbanColumn::class, KanbanTask::class], version = 1)
abstract class KanbanDatabase : RoomDatabase() {

    abstract fun projectDao(): KanbanProjectDao

    abstract fun columnDao(): KanbanColumnDao

    abstract fun taskDao(): KanbanTaskDao

    companion object {
        const val DATABASE_NAME = "kanban_database"
    }
}

// TODO: re-enable code when jvm for KMP
//expect fun createKanbanDatabase(context: PlatformContext, databaseName: String): KanbanDatabase