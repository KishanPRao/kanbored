package com.kanbored.kanbored.model

import com.kanbored.kanbored.network.Result
import kotlinx.coroutines.flow.Flow

interface KanbanQueryOperations {
    fun getAllProjects(): Flow<List<KanbanProject>>

    fun getProject(id: Int): Flow<KanbanProject?>

    fun getColumns(projectId: Int): Flow<List<KanbanColumn>>

    fun getTasks(projectId: Int, columnId: Int): Flow<List<KanbanTask>>

    fun getTask(projectId: Int, columnId: Int, taskId: Int): Flow<KanbanTask?>

    fun getSubtasks(taskId: Int): Flow<List<KanbanSubtask>>

    fun getComments(taskId: Int): Flow<List<KanbanComment>>

    suspend fun refreshProjects(): Result<Unit>

    suspend fun refreshColumns(projectId: Int): Result<Unit>

    suspend fun refreshTasks(projectId: Int, isArchived: Boolean): Result<Unit>

    suspend fun refreshSubtasks(taskId: Int): Result<Unit>

    suspend fun refreshComments(taskId: Int): Result<Unit>
}

interface KanbanCommandOperations {
    suspend fun createProject(name: String): KanbanProject

    suspend fun createColumn(projectId: Int, name: String): KanbanColumn

    suspend fun createTask(projectId: Int, columnId: Int, name: String): KanbanTask

    suspend fun updateProject(project: KanbanProject)

    suspend fun updateTask(task: KanbanTask)

    suspend fun deleteProject(project: KanbanProject)

    suspend fun deleteTask(task: KanbanTask)
}