package com.kanbored.kanbored.persistent

import android.content.Context
import androidx.room.Dao
import androidx.room.Database
import androidx.room.Delete
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import androidx.room.Room
import androidx.room.RoomDatabase
import androidx.room.Update
import com.kanbored.kanbored.model.KanbanProject
import com.kanbored.kanbored.model.KanbanUserSession

const val kanbanProjectTableName = "kanban_project"
const val kanbanUserSessionTableName = "kanban_user_session"
const val databaseName = "kanban_database"

@Dao
interface KanbanProjectDao {
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertOrUpdate(project: KanbanProject)

    @Update
    suspend fun update(project: KanbanProject)

    @Delete
    suspend fun delete(project: KanbanProject)

    @Query("select * from $kanbanProjectTableName")
    suspend fun getAllProjects(): List<KanbanProject>
}

@Dao
interface KanbanUserSessionDao {
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertOrUpdate(userSession: KanbanUserSession)

    @Update
    suspend fun update(userSession: KanbanUserSession)

    @Delete
    suspend fun delete(userSession: KanbanUserSession)

    @Query("select * from $kanbanUserSessionTableName where authenticated == 1")  // TODO: limit 1?
    suspend fun getAuthenticatedUserSessionSync(): KanbanUserSession?
}

@Database(entities = [KanbanUserSession::class, KanbanProject::class], version = 1)
abstract class KanbanDatabase : RoomDatabase() {

    abstract fun projectDao(): KanbanProjectDao
    abstract fun userSessionDao(): KanbanUserSessionDao

    companion object {
        private var instance: KanbanDatabase? = null

        fun getDatabase(context: Context): KanbanDatabase {
            return instance ?: synchronized(this) {
                Room.databaseBuilder(
                    context,
                    KanbanDatabase::class.java,
                    databaseName
                )
                    .build()
                    .also {
                        instance = it
                    }
            }
        }
    }
}