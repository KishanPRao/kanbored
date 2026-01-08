package com.kanbored.kanbored.persistent

import androidx.room.Dao
import androidx.room.Delete
import androidx.room.Query
import androidx.room.Update
import androidx.room.Upsert
import com.kanbored.kanbored.model.ApiStorage
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
const val apiStorageTableName = "api_storage"

@Dao
interface BaseDao<T> {
    @Upsert
    suspend fun upsert(item: T)

    @Upsert
    suspend fun upsertAll(items: List<T>)

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

    @Query("select * from $kanbanProjectTableName where id == :id")
    fun getSingle(id: Int): Flow<KanbanProject>

    @Query("update $kanbanProjectTableName set id = :newId where id == :oldId")
    suspend fun updateId(oldId: Int, newId: Int)
}

@Dao
interface KanbanColumnDao : BaseDao<KanbanColumn> {
    @Query("select * from $kanbanColumnTableName where projectId == :projectId order by position")
    fun get(projectId: Int): Flow<List<KanbanColumn>>

    @Query("select * from $kanbanColumnTableName")
    fun getAll(): Flow<List<KanbanColumn>>

    @Query("select max(position) from $kanbanColumnTableName where projectId == :projectId")
    suspend fun getLargestPositionSync(projectId: Int): Int?

    @Query("select * from $kanbanColumnTableName")
    suspend fun getAllSync(): List<KanbanColumn>

    @Query("update $kanbanColumnTableName set id = :newId where id == :oldId")
    suspend fun updateId(oldId: Int, newId: Int)
}

@Dao
interface KanbanTaskDao : BaseDao<KanbanTask> {
    @Query("select * from $kanbanTaskTableName where columnId == :columnId and projectId == :projectId order by position")
    fun get(projectId: Int, columnId: Int): Flow<List<KanbanTask>>

    @Query("select * from $kanbanTaskTableName where columnId == :columnId and projectId == :projectId and id == :taskId")
    fun getSingle(projectId: Int, columnId: Int, taskId: Int): Flow<KanbanTask?>

    @Query("select max(position) from $kanbanTaskTableName where columnId == :columnId and projectId == :projectId")
    suspend fun getLargestPositionSync(projectId: Int, columnId: Int): Int?

    @Query("select * from $kanbanTaskTableName")
    suspend fun getAllSync(): List<KanbanTask>

    @Query("update $kanbanTaskTableName set id = :newId where id == :oldId")
    suspend fun updateId(oldId: Int, newId: Int)
}

@Dao
interface KanbanSubtaskDao : BaseDao<KanbanSubtask> {
    @Query("select * from $kanbanSubtaskTableName where taskId == :taskId order by position")
    fun get(taskId: Int): Flow<List<KanbanSubtask>>

    @Query("select * from $kanbanSubtaskTableName")
    suspend fun getAllSync(): List<KanbanSubtask>

    @Query("update $kanbanSubtaskTableName set id = :newId where id == :oldId")
    suspend fun updateId(oldId: Int, newId: Int)
}

@Dao
interface KanbanCommentDao : BaseDao<KanbanComment> {
    @Query("select * from $kanbanCommentTableName where taskId == :taskId order by dateCreation")
    fun get(taskId: Int): Flow<List<KanbanComment>>

    @Query("select * from $kanbanCommentTableName")
    suspend fun getAllSync(): List<KanbanComment>

    @Query("update $kanbanSubtaskTableName set id = :newId where id == :oldId")
    suspend fun updateId(oldId: Int, newId: Int)
}

@Dao
interface ApiStorageDao : BaseDao<ApiStorage> {
    @Query("select * from $apiStorageTableName")
    fun getAll(): Flow<List<ApiStorage>>

    @Query("select * from $apiStorageTableName")
    suspend fun getAllSync(): List<ApiStorage>

    @Query("select min(updateId) from $apiStorageTableName")
    fun getNextId(): Int

    @Query("select * from $apiStorageTableName order by timestamp asc limit 1")
    fun getNextApi(): ApiStorage?

    @Query("update $apiStorageTableName set projectId = :newId where projectId == :oldId")
    suspend fun updateProjectId(oldId: Int, newId: Int)

    @Query("update $apiStorageTableName set columnId = :newId where columnId == :oldId")
    suspend fun updateColumnId(oldId: Int, newId: Int)

    @Query("update $apiStorageTableName set taskId = :newId where taskId == :oldId")
    suspend fun updateTaskId(oldId: Int, newId: Int)

    // TODO: better name
    @Query("update $apiStorageTableName set updateId = :newId where updateId == :oldId")
    suspend fun updateUpdateId(oldId: Int, newId: Int)
}

interface KanbanDatabase {

    fun projectDao(): KanbanProjectDao

    fun columnDao(): KanbanColumnDao

    fun taskDao(): KanbanTaskDao

    fun subtaskDao(): KanbanSubtaskDao

    fun commentDao(): KanbanCommentDao

    fun apiStorageDao(): ApiStorageDao

    companion object {
        const val DATABASE_NAME = "kanban_database"
    }
}

// TODO: re-enable code when jvm for KMP
//expect fun createKanbanDatabase(context: PlatformContext, databaseName: String): KanbanDatabase