package com.kanbored.kanbored.model

import androidx.room.Entity
import androidx.room.PrimaryKey
import com.kanbored.kanbored.persistent.kanbanProjectTableName
import kotlinx.serialization.SerialName

@Entity(tableName = kanbanProjectTableName)
data class KanbanProject(
    @PrimaryKey val id: Int,
    val name: String,
    @SerialName("is_active") val isActive: Boolean,
    val token: String,
    @SerialName("last_modified") val lastModified: Int,
    @SerialName("is_public") val isPublic: Int,
    @SerialName("is_private") val isPrivate: Int,
    val description: Int,
    val identifier: Int,
    @SerialName("start_date") val startDate: Int,
    @SerialName("end_date") val endDate: Int,
    @SerialName("owner_id") val ownerId: Int,
    @SerialName("priority_default") val priorityDefault: Int,
    @SerialName("priority_start") val priorityStart: Int,
    @SerialName("priority_end") val priorityEnd: Int,
    val email: Int,
    @SerialName("predefined_email_subjects") val predefinedEmailSubjects: Int,
    @SerialName("per_swimlane_task_limits") val perSwimlaneTaskLimits: Int,
    @SerialName("task_limit") val taskLimit: Int,
    @SerialName("enable_global_tags") val enableGlobalTags: Int,
    @SerialName("is_trello_imported") val isTrelloImported: Int,
    val url: Int,
)