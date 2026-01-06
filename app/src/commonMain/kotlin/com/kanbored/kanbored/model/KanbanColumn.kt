package com.kanbored.kanbored.model

import androidx.room.Entity
import androidx.room.ForeignKey
import androidx.room.PrimaryKey
import com.kanbored.kanbored.persistent.kanbanColumnTableName
import com.kanbored.kanbored.utils.BooleanAsIntSerializer
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

// TODO: foreign key constraint causes crash; investigate further!
@Entity(
    tableName = kanbanColumnTableName,
    foreignKeys = [ForeignKey(
        entity = KanbanProject::class,
        parentColumns = ["id"],
        childColumns = ["projectId"],
        onUpdate = ForeignKey.CASCADE,
        onDelete = ForeignKey.CASCADE,  // TODO: confirm
    )],
)
@Serializable
data class KanbanColumn(
    @PrimaryKey val id: Int,
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
/*
TODO: projectId column references a foreign key but it is not part of an index. This may trigger full table scans whenever parent table is modified so you are highly advised to create an index that covers this column
 */