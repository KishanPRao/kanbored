package com.kanbored.kanbored.model

import androidx.room.Entity
import androidx.room.ForeignKey
import androidx.room.PrimaryKey
import com.kanbored.kanbored.persistent.kanbanTaskTableName
import com.kanbored.kanbored.utils.BooleanAsIntSerializer
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Entity(
    tableName = kanbanTaskTableName,
    foreignKeys = [
        ForeignKey(
            entity = KanbanColumn::class,
            parentColumns = ["id"],
            childColumns = ["columnId"],
            onUpdate = ForeignKey.CASCADE,
            onDelete = ForeignKey.CASCADE,  // TODO: confirm
        ),
        ForeignKey(
            entity = KanbanProject::class,
            parentColumns = ["id"],
            childColumns = ["projectId"],
            onUpdate = ForeignKey.CASCADE,
            onDelete = ForeignKey.CASCADE,  // TODO: confirm
        ),
    ],
)
@Serializable
data class KanbanTask(
    @PrimaryKey val id: Int,
    val title: String,
    val description: String,
    @SerialName("date_creation") val dateCreation: Int,
    @SerialName("color_id") val colorId: String,
    @SerialName("project_id") val projectId: Int,
    @SerialName("column_id") val columnId: Int,
    @SerialName("owner_id") val ownerId: Int,
    val position: Int,
    @Serializable(with = BooleanAsIntSerializer::class)
    @SerialName("is_active") val isActive: Boolean,
    @SerialName("date_completed") val dateCompleted: Int?,
    val score: Int?,
    @SerialName("date_due") val dateDue: Int?,
    @SerialName("category_id") val categoryId: Int,
    @SerialName("creator_id") val creatorId: Int,
    @SerialName("date_modification") val dateModification: Int?,
    val reference: String?,
    @SerialName("date_started") val dateStarted: Int?,
    @SerialName("time_spent") val timeSpent: Int?,
    @SerialName("time_estimated") val timeEstimated: Int?,
    @SerialName("swimlane_id") val swimlaneId: Int = 0,
    @SerialName("date_moved") val dateMoved: Int,
    @SerialName("recurrence_status") val recurrenceStatus: Int,
    @SerialName("recurrence_trigger") val recurrenceTrigger: Int,
    @SerialName("recurrence_factor") val recurrenceFactor: Int,
    @SerialName("recurrence_timeframe") val recurrenceTimeframe: Int,
    @SerialName("recurrence_basedate") val recurrenceBasedate: Int,
    @SerialName("recurrence_parent") val recurrenceParent: Int?,
    @SerialName("recurrence_child") val recurrenceChild: Int?,
    val priority: Int,
//    val nbComments: Int,
//    val nbFiles: Int,
//    val nbLinks: Int,
//    val nbExternalLinks: Int,
//    val nbSubtasks: Int,
//    val nbCompletedSubtasks: Int,
)