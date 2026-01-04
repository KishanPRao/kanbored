package com.kanbored.kanbored.persistent

import com.kanbored.kanbored.model.ApiStorage
import com.kanbored.kanbored.model.KanbanColumn
import com.kanbored.kanbored.model.KanbanComment
import com.kanbored.kanbored.model.KanbanProject
import com.kanbored.kanbored.model.KanbanSubtask
import com.kanbored.kanbored.model.KanbanTask
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import kotlin.concurrent.atomics.AtomicInt
import kotlin.concurrent.atomics.ExperimentalAtomicApi

abstract class MockBaseDao<T> : BaseDao<T> {
    val items = mutableListOf<T>()

    override suspend fun insertAll(items: List<T>) {
        this.items.addAll(items)
    }

    override suspend fun update(item: T) {
        insertOrUpdate(item)
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

    open suspend fun updateId(oldId: Int, newId: Int) {
        println("updateId: $oldId -> $newId")
    }

    fun clear() {
        items.clear()
    }
}

object MockKanbanProjectDao : KanbanProjectDao, MockBaseDao<KanbanProject>() {
    override suspend fun insertOrUpdate(item: KanbanProject) {
        items.firstOrNull { it.id == item.id }?.let { delete(it) }
        items.add(item)
    }

    override suspend fun updateId(oldId: Int, newId: Int) {
        super.updateId(oldId, newId)
        items.filter { it.id == oldId }
            .onEach { delete(it) }
            .onEach { insertOrUpdate(it.copy(id = newId)) }
        MockKanbanColumnDao.updateAllProjectId(oldId, newId)
        MockKanbanTaskDao.updateAllProjectId(oldId, newId)
    }
}

object MockKanbanColumnDao : KanbanColumnDao, MockBaseDao<KanbanColumn>() {
    override suspend fun insertOrUpdate(item: KanbanColumn) {
        items.firstOrNull { it.id == item.id }?.let { delete(it) }
        items.add(item)
    }

    override fun get(projectId: Int): Flow<List<KanbanColumn>> {
        TODO("Not yet implemented")
    }

    override suspend fun updateId(oldId: Int, newId: Int) {
        super.updateId(oldId, newId)
        items.filter { it.id == oldId }
            .onEach { delete(it) }
            .onEach { insertOrUpdate(it.copy(id = newId)) }
        MockKanbanTaskDao.updateAllColumnId(oldId, newId)
    }

    suspend fun updateAllProjectId(oldId: Int, newId: Int) {
        items.filter { it.projectId == oldId }
            .onEach { delete(it) }
            .onEach { insertOrUpdate(it.copy(projectId = newId)) }
    }
}

object MockKanbanTaskDao : KanbanTaskDao, MockBaseDao<KanbanTask>() {
    override suspend fun insertOrUpdate(item: KanbanTask) {
        items.firstOrNull { it.id == item.id }?.let { delete(it) }
        items.add(item)
    }

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

    override suspend fun updateId(oldId: Int, newId: Int) {
        super.updateId(oldId, newId)
        items.filter { it.id == oldId }
            .onEach { delete(it) }
            .onEach { insertOrUpdate(it.copy(id = newId)) }
        MockKanbanSubtaskDao.updateAllTaskId(oldId, newId)
        MockKanbanCommentDao.updateAllTaskId(oldId, newId)
    }

    suspend fun updateAllProjectId(oldId: Int, newId: Int) {
        items.filter { it.projectId == oldId }
            .onEach { delete(it) }
            .onEach { insertOrUpdate(it.copy(projectId = newId)) }
    }

    suspend fun updateAllColumnId(oldId: Int, newId: Int) {
        items.filter { it.columnId == oldId }
            .onEach { delete(it) }
            .onEach { insertOrUpdate(it.copy(columnId = newId)) }
    }
}

object MockKanbanSubtaskDao : KanbanSubtaskDao, MockBaseDao<KanbanSubtask>() {
    override suspend fun insertOrUpdate(item: KanbanSubtask) {
        items.firstOrNull { it.id == item.id }?.let { delete(it) }
        items.add(item)
    }

    override fun get(taskId: Int): Flow<List<KanbanSubtask>> {
        TODO("Not yet implemented")
    }

    override suspend fun updateId(oldId: Int, newId: Int) {
        super.updateId(oldId, newId)
        items.filter { it.id == oldId }
            .onEach { delete(it) }
            .onEach { insertOrUpdate(it.copy(id = newId)) }
    }

    suspend fun updateAllTaskId(oldId: Int, newId: Int) {
        items.filter { it.taskId == oldId }
            .onEach { delete(it) }
            .onEach { insertOrUpdate(it.copy(taskId = newId)) }
    }
}

object MockKanbanCommentDao : KanbanCommentDao, MockBaseDao<KanbanComment>() {
    override suspend fun insertOrUpdate(item: KanbanComment) {
        items.firstOrNull { it.id == item.id }?.let { delete(it) }
        items.add(item)
    }

    override fun get(taskId: Int): Flow<List<KanbanComment>> {
        TODO("Not yet implemented")
    }

    override suspend fun updateId(oldId: Int, newId: Int) {
        super.updateId(oldId, newId)
        items.filter { it.id == oldId }
            .onEach { delete(it) }
            .onEach { insertOrUpdate(it.copy(id = newId)) }
    }

    suspend fun updateAllTaskId(oldId: Int, newId: Int) {
        items.filter { it.taskId == oldId }
            .onEach { delete(it) }
            .onEach { insertOrUpdate(it.copy(taskId = newId)) }
    }
}

@OptIn(ExperimentalAtomicApi::class)
object MockApiStorageDao : ApiStorageDao, MockBaseDao<ApiStorage>() {
    override suspend fun insertOrUpdate(item: ApiStorage) {
        items.firstOrNull { it.id == item.id }?.let { delete(it) }
        items.add(item)
    }

    private var nextUpdateId = AtomicInt(-1)

    override fun getNextId(): Int {
        return nextUpdateId.fetchAndAdd(-1)
    }

    override fun getNextApi(): ApiStorage? {
        return items.minByOrNull { it.timestamp }
    }

    override suspend fun updateProjectId(oldId: Int, newId: Int) {
        items.filter { it.kanbanParams.projectId == oldId }
            .onEach { delete(it) }
            .onEach { insertOrUpdate(it.copy(kanbanParams = it.kanbanParams.copy(projectId = newId))) }
    }

    override suspend fun updateColumnId(oldId: Int, newId: Int) {
        items.filter { it.kanbanParams.columnId == oldId }
            .onEach { delete(it) }
            .onEach { insertOrUpdate(it.copy(kanbanParams = it.kanbanParams.copy(columnId = newId))) }
    }

    override suspend fun updateTaskId(oldId: Int, newId: Int) {
        items.filter { it.kanbanParams.taskId == oldId }
            .onEach { delete(it) }
            .onEach { insertOrUpdate(it.copy(kanbanParams = it.kanbanParams.copy(taskId = newId))) }
    }
}