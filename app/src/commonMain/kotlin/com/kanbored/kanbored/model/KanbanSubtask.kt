package com.kanbored.kanbored.model

import androidx.room.Entity
import androidx.room.ForeignKey
import androidx.room.PrimaryKey
import com.kanbored.kanbored.persistent.kanbanSubtaskTableName
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Entity(
    tableName = kanbanSubtaskTableName,
    foreignKeys = [ForeignKey(
        entity = KanbanTask::class,
        parentColumns = ["id"],
        childColumns = ["taskId"],
        onUpdate = ForeignKey.CASCADE,
        onDelete = ForeignKey.CASCADE,  // TODO: confirm
    )],
)
@Serializable
data class KanbanSubtask(
    @PrimaryKey val id: Int,
    val title: String,
    val status: Int,
    @SerialName("time_estimated") val timeEstimated: Int,
    @SerialName("time_spent") val timeSpent: Int,
    @SerialName("task_id") val taskId: Int,
    @SerialName("user_id") val userId: Int,
    val position: Int,
    val username: String?,
    val name: String?,
    @SerialName("timer_start_date") val timerStartDate: Int,
    @SerialName("status_name") val statusName: String,
    @SerialName("is_timer_started") val isTimerStarted: Boolean,
)


const val KanbanSubtaskTodo = 0
const val KanbanSubtaskInProgress = 1
const val KanbanSubtaskFinished = 2