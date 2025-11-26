package com.kanbored.kanbored.persistent

import android.content.Context
import androidx.room.ColumnInfo
import androidx.room.Dao
import androidx.room.Database
import androidx.room.Delete
import androidx.room.Entity
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.PrimaryKey
import androidx.room.Query
import androidx.room.Room
import androidx.room.RoomDatabase
import androidx.room.Update

const val userSessionTableName = "kanban_user_session"
const val databaseName = "kanban_database"

@Entity(tableName = userSessionTableName)
data class KanbanUserSessionEntity(
    @PrimaryKey
    @ColumnInfo(name = "user_id") val userId: Int,
    @ColumnInfo(name = "user_name") val userName: String,
    val password: String,
    @ColumnInfo(name = "host_url") val hostUrl: String,
    @ColumnInfo(name = "app_role") val appRole: String,
    val authenticated: Boolean,
)

@Dao
interface UserDao {
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertOrUpdate(userSessionEntity: KanbanUserSessionEntity)

    @Update
    suspend fun update(userSessionEntity: KanbanUserSessionEntity)

    @Delete
    suspend fun delete(userSessionEntity: KanbanUserSessionEntity)

    @Query("select * from $userSessionTableName where authenticated == 1")  // TODO: limit 1?
    suspend fun getAuthenticatedUserSessionSync(): KanbanUserSessionEntity?
}

@Database(entities = [KanbanUserSessionEntity::class], version = 1)
abstract class KanbanDatabase : RoomDatabase() {

    abstract fun userDao(): UserDao

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