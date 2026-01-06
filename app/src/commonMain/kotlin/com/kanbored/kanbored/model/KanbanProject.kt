package com.kanbored.kanbored.model

import androidx.room.Embedded
import androidx.room.Entity
import androidx.room.PrimaryKey
import com.kanbored.kanbored.persistent.kanbanProjectTableName
import com.kanbored.kanbored.utils.BooleanAsIntSerializer
import com.kanbored.kanbored.utils.emptyProject
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Entity(tableName = kanbanProjectTableName)
@Serializable
data class KanbanProject(
    @PrimaryKey val id: Int,
    val name: String,
    @Serializable(with = BooleanAsIntSerializer::class)
    @SerialName("is_active") val isActive: Boolean,
    val token: String,
    @SerialName("last_modified") val lastModified: Int,
    @SerialName("is_public") val isPublic: Int,
    @SerialName("is_private") val isPrivate: Int,
    val description: String?,
    val identifier: String,
    @SerialName("start_date") val startDate: String,
    @SerialName("end_date") val endDate: String,
    @SerialName("owner_id") val ownerId: Int,
    @SerialName("priority_default") val priorityDefault: Int,
    @SerialName("priority_start") val priorityStart: Int,
    @SerialName("priority_end") val priorityEnd: Int,
    val email: String?,
    @SerialName("predefined_email_subjects") val predefinedEmailSubjects: String?,
    @SerialName("per_swimlane_task_limits") val perSwimlaneTaskLimits: Int,
    @SerialName("task_limit") val taskLimit: Int,
    @SerialName("enable_global_tags") val enableGlobalTags: Int,
    @Serializable(with = BooleanAsIntSerializer::class)
    @SerialName("is_trello_imported") val isTrelloImported: Boolean,
    @Embedded(prefix = "url_")
    val url: KanbanUrl,
) {
    fun isValid(): Boolean {
        return this != emptyProject
    }
}

@Serializable
data class KanbanUrl(
    val board: String,
    val list: String,
)