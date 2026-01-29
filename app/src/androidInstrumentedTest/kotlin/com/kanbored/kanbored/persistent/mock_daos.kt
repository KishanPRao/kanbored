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

    override suspend fun upsertAll(items: List<T>) {
        this.items.addAll(items)
    }

    override suspend fun update(item: T) {
        upsert(item)
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
    override suspend fun upsert(item: KanbanProject) {
        items.firstOrNull { it.id == item.id }?.let { delete(it) }
        items.add(item)
    }

    override fun getSingle(id: Int): Flow<KanbanProject> {
        TODO("Not yet implemented")
    }

    override suspend fun updateId(oldId: Int, newId: Int) {
        super.updateId(oldId, newId)
        items.filter { it.id == oldId }
            .onEach { delete(it) }
            .onEach { upsert(it.copy(id = newId)) }
        MockKanbanColumnDao.updateAllProjectId(oldId, newId)
        MockKanbanTaskDao.updateAllProjectId(oldId, newId)
    }
}

object MockKanbanColumnDao : KanbanColumnDao, MockBaseDao<KanbanColumn>() {
    override suspend fun upsert(item: KanbanColumn) {
        items.firstOrNull { it.id == item.id }?.let { delete(it) }
        items.add(item)
    }

    override fun get(projectId: Int): Flow<List<KanbanColumn>> {
        TODO("Not yet implemented")
    }

    override suspend fun getLargestPositionSync(projectId: Int): Int? {
        return items.maxOfOrNull { it.position }
    }

    override suspend fun updateId(oldId: Int, newId: Int) {
        super.updateId(oldId, newId)
        items.filter { it.id == oldId }
            .onEach { delete(it) }
            .onEach { upsert(it.copy(id = newId)) }
        MockKanbanTaskDao.updateAllColumnId(oldId, newId)
    }

    suspend fun updateAllProjectId(oldId: Int, newId: Int) {
        items.filter { it.projectId == oldId }
            .onEach { delete(it) }
            .onEach { upsert(it.copy(projectId = newId)) }
    }
}

object MockKanbanTaskDao : KanbanTaskDao, MockBaseDao<KanbanTask>() {
    override suspend fun upsert(item: KanbanTask) {
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

    override suspend fun getLargestPositionSync(
        projectId: Int,
        columnId: Int
    ): Int? {
        return items.maxOfOrNull { it.position }
    }

    override suspend fun updateId(oldId: Int, newId: Int) {
        super.updateId(oldId, newId)
        items.filter { it.id == oldId }
            .onEach { delete(it) }
            .onEach { upsert(it.copy(id = newId)) }
        MockKanbanSubtaskDao.updateAllTaskId(oldId, newId)
        MockKanbanCommentDao.updateAllTaskId(oldId, newId)
    }

    suspend fun updateAllProjectId(oldId: Int, newId: Int) {
        items.filter { it.projectId == oldId }
            .onEach { delete(it) }
            .onEach { upsert(it.copy(projectId = newId)) }
    }

    suspend fun updateAllColumnId(oldId: Int, newId: Int) {
        items.filter { it.columnId == oldId }
            .onEach { delete(it) }
            .onEach { upsert(it.copy(columnId = newId)) }
    }
}

object MockKanbanSubtaskDao : KanbanSubtaskDao, MockBaseDao<KanbanSubtask>() {
    override suspend fun upsert(item: KanbanSubtask) {
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
            .onEach { upsert(it.copy(id = newId)) }
    }

    suspend fun updateAllTaskId(oldId: Int, newId: Int) {
        items.filter { it.taskId == oldId }
            .onEach { delete(it) }
            .onEach { upsert(it.copy(taskId = newId)) }
    }
}

object MockKanbanCommentDao : KanbanCommentDao, MockBaseDao<KanbanComment>() {
    override suspend fun upsert(item: KanbanComment) {
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
            .onEach { upsert(it.copy(id = newId)) }
    }

    suspend fun updateAllTaskId(oldId: Int, newId: Int) {
        items.filter { it.taskId == oldId }
            .onEach { delete(it) }
            .onEach { upsert(it.copy(taskId = newId)) }
    }
}

@OptIn(ExperimentalAtomicApi::class)
object MockApiStorageDao : ApiStorageDao, MockBaseDao<ApiStorage>() {
    override suspend fun upsert(item: ApiStorage) {
        items.firstOrNull { it.apiStorageId == item.apiStorageId }?.let { delete(it) }
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
            .onEach { upsert(it.copy(kanbanParams = it.kanbanParams.copy(projectId = newId))) }
    }

    override suspend fun updateColumnId(oldId: Int, newId: Int) {
        items.filter { it.kanbanParams.columnId == oldId }
            .onEach { delete(it) }
            .onEach { upsert(it.copy(kanbanParams = it.kanbanParams.copy(columnId = newId))) }
    }

    override suspend fun updateTaskId(oldId: Int, newId: Int) {
        items.filter { it.kanbanParams.taskId == oldId }
            .onEach { delete(it) }
            .onEach { upsert(it.copy(kanbanParams = it.kanbanParams.copy(taskId = newId))) }
    }

    override suspend fun updateUpdateId(oldId: Int, newId: Int) {
        items.filter { it.updateId == oldId }
            .onEach { delete(it) }
            .onEach { upsert(it.copy(updateId = newId)) }
    }

    override suspend fun delete(apiStorageId: Int) {
        items.removeIf { it.apiStorageId == apiStorageId }
    }
}