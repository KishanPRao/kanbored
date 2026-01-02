package com.kanbored.kanbored.model

import androidx.room.Entity
import com.kanbored.kanbored.persistent.kanbanCommentTableName
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Entity(tableName = kanbanCommentTableName, primaryKeys = ["id", "taskId"])
@Serializable
data class KanbanComment(
    val id: Int,
    @SerialName("date_creation") val dateCreation: Int,
    @SerialName("date_modification") val dateModification: Int,
    @SerialName("task_id") val taskId: Int,
    @SerialName("user_id") val userId: Int,
    val comment: String,
    val username: String?,
    val name: String?,
    val email: String?,
    @SerialName("avatar_path") val avatarPath: String?,
)