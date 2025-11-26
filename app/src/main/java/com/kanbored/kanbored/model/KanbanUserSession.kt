package com.kanbored.kanbored.model

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey
import com.kanbored.kanbored.persistent.kanbanUserSessionTableName

@Entity(tableName = kanbanUserSessionTableName)
data class KanbanUserSession(
    @PrimaryKey
    @ColumnInfo(name = "user_id") val userId: Int,
    @ColumnInfo(name = "user_name") val userName: String,
    val password: String,
    @ColumnInfo(name = "host_url") val hostUrl: String,
    @ColumnInfo(name = "app_role") val appRole: String,
    val authenticated: Boolean,
)