package com.kanbored.kanbored.model

import androidx.room.Entity
import com.kanbored.kanbored.persistent.kanbanColumnTableName
import com.kanbored.kanbored.utils.BooleanAsIntSerializer
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Entity(tableName = kanbanColumnTableName, primaryKeys = ["id", "projectId"])
@Serializable
data class KanbanColumn(
    val id: Int,
    val title: String,
    val position: Int,
    @SerialName("task_limit") val taskLimit: Int,
    val description: String,
    @Serializable(with = BooleanAsIntSerializer::class)
    @SerialName("hide_in_dashboard") val hideInDashboard: Boolean,
    @SerialName("project_id") val projectId: Int,
//    val nbOpenTasks: Int,
//    val nbClosedTasks: Int,
//    val nbTasks: Int,
//    val score: Int,
//    val tasks: List<KanbanTask>,
//    val columnNbTasks: Int,
//    val columnScore: Int,
//    val columnNbScore: Int,
//    val columnNbOpenTasks: Int,
//    val isActive: Boolean,
)