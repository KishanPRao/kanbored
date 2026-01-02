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
import com.kanbored.kanbored.model.KanbanComment
import com.kanbored.kanbored.model.KanbanProject
import com.kanbored.kanbored.model.KanbanSubtask
import com.kanbored.kanbored.model.KanbanTask
import kotlinx.coroutines.flow.Flow

const val kanbanProjectTableName = "kanban_project"
const val kanbanColumnTableName = "kanban_column"
const val kanbanTaskTableName = "kanban_task"
const val kanbanSubtaskTableName = "kanban_subtask"
const val kanbanCommentTableName = "kanban_comment"

@Dao
interface BaseDao<T> {
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertOrUpdate(item: T)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertAll(items: List<T>)

    @Update
    suspend fun update(item: T)

    @Delete
    suspend fun delete(item: T)

    // TODO: try to have common getAll
}

@Dao
interface KanbanProjectDao : BaseDao<KanbanProject> {
    @Query("select * from $kanbanProjectTableName")
    fun getAll(): Flow<List<KanbanProject>>

    @Query("select * from $kanbanProjectTableName")
    suspend fun getAllSync(): List<KanbanProject>
}

@Dao
interface KanbanColumnDao : BaseDao<KanbanColumn> {
    @Query("select * from $kanbanColumnTableName where projectId == :projectId")
    fun get(projectId: Int): Flow<List<KanbanColumn>>

    @Query("select * from $kanbanColumnTableName")
    fun getAll(): Flow<List<KanbanColumn>>

    @Query("select * from $kanbanColumnTableName")
    suspend fun getAllSync(): List<KanbanColumn>
}

@Dao
interface KanbanTaskDao : BaseDao<KanbanTask> {
    @Query("select * from $kanbanTaskTableName where columnId == :columnId and projectId == :projectId")
    fun get(projectId: Int, columnId: Int): Flow<List<KanbanTask>>

    @Query("select * from $kanbanTaskTableName where columnId == :columnId and projectId == :projectId and id == :taskId")
    fun getSingle(projectId: Int, columnId: Int, taskId: Int): Flow<KanbanTask?>
}

@Dao
interface KanbanSubtaskDao : BaseDao<KanbanSubtask> {
    @Query("select * from $kanbanSubtaskTableName where taskId == :taskId")
    fun get(taskId: Int): Flow<List<KanbanSubtask>>
}

@Dao
interface KanbanCommentDao : BaseDao<KanbanComment> {
    @Query("select * from $kanbanCommentTableName where taskId == :taskId")
    fun get(taskId: Int): Flow<List<KanbanComment>>
}

@Database(
    entities = [
        KanbanProject::class,
        KanbanColumn::class,
        KanbanTask::class,
        KanbanSubtask::class,
        KanbanComment::class
    ],
    version = 1
)
abstract class KanbanDatabase : RoomDatabase() {

    abstract fun projectDao(): KanbanProjectDao

    abstract fun columnDao(): KanbanColumnDao

    abstract fun taskDao(): KanbanTaskDao

    abstract fun subtaskDao(): KanbanSubtaskDao

    abstract fun commentDao(): KanbanCommentDao

    companion object {
        const val DATABASE_NAME = "kanban_database"
    }
}

// TODO: re-enable code when jvm for KMP
//expect fun createKanbanDatabase(context: PlatformContext, databaseName: String): KanbanDatabase