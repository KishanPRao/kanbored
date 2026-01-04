package com.kanbored.kanbored.model

import androidx.room.Embedded
import androidx.room.Entity
import androidx.room.PrimaryKey
import com.kanbored.kanbored.network.KanbanMethod
import com.kanbored.kanbored.network.KanbanParams
import com.kanbored.kanbored.persistent.apiStorageTableName
import com.kanbored.kanbored.utils.getTimestampInMs

@Entity(tableName = apiStorageTableName)
data class ApiStorage(
    @Embedded val kanbanMethod: KanbanMethod,
    @Embedded val kanbanParams: KanbanParams,
    val updateId: Int,
    val timestamp: Long = getTimestampInMs(),
    @PrimaryKey(autoGenerate = true) val id: Int = 0,
)