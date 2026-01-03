package com.kanbored.kanbored.persistent

import com.kanbored.kanbored.model.ApiStorage
import com.kanbored.kanbored.model.KanbanColumn
import com.kanbored.kanbored.model.KanbanComment
import com.kanbored.kanbored.model.KanbanProject
import com.kanbored.kanbored.model.KanbanSubtask
import com.kanbored.kanbored.model.KanbanTask
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow

abstract class MockBaseDao<T> : BaseDao<T> {
    val items = mutableListOf<T>()

    override suspend fun insertOrUpdate(item: T) {
        delete(item)
        items.add(item)
    }

    override suspend fun insertAll(items: List<T>) {
        this.items.addAll(items)
    }

    override suspend fun update(item: T) {
        insertOrUpdate(item)    // NOTE: Obviously not correct, but need to somehow identify primary key to be correct
    }

    override suspend fun delete(item: T) {
        if (items.contains(item))
            items.remove(item)
    }

    fun getAll(): Flow<List<T>> {
        return flow { items }
    }

    suspend fun getAllSync(): List<T> {
        return items
    }
}

object MockKanbanProjectDao : KanbanProjectDao, MockBaseDao<KanbanProject>()

object MockKanbanColumnDao : KanbanColumnDao, MockBaseDao<KanbanColumn>() {
    override fun get(projectId: Int): Flow<List<KanbanColumn>> {
        TODO("Not yet implemented")
    }
}

object MockKanbanTaskDao : KanbanTaskDao, MockBaseDao<KanbanTask>() {
    override fun get(
        projectId: Int,
        columnId: Int
    ): Flow<List<KanbanTask>> {
        TODO("Not yet implemented")
    }

    override fun getSingle(
        projectId: Int,
        columnId: Int,
        taskId: Int
    ): Flow<KanbanTask?> {
        TODO("Not yet implemented")
    }
}

object MockKanbanSubtaskDao : KanbanSubtaskDao, MockBaseDao<KanbanSubtask>() {
    override fun get(taskId: Int): Flow<List<KanbanSubtask>> {
        TODO("Not yet implemented")
    }
}

object MockKanbanCommentDao : KanbanCommentDao, MockBaseDao<KanbanComment>() {
    override fun get(taskId: Int): Flow<List<KanbanComment>> {
        TODO("Not yet implemented")
    }
}

object MockApiStorageDao : ApiStorageDao, MockBaseDao<ApiStorage>() {
    override fun getNextId(): Int {
        return (items.minOfOrNull { it.id } ?: 0) - 1
    }

    override fun getNextApi(): ApiStorage? {
        return items.minByOrNull { it.timestamp }
    }
}