package com.kanbored.kanbored.viewmodel

import androidx.lifecycle.viewModelScope
import com.kanbored.kanbored.event.AppEventBus
import com.kanbored.kanbored.event.AppUiEvent
import com.kanbored.kanbored.model.KanbanComment
import com.kanbored.kanbored.model.KanbanSubtask
import com.kanbored.kanbored.model.KanbanTask
import com.kanbored.kanbored.network.ConnectivityListener
import com.kanbored.kanbored.network.Result
import com.kanbored.kanbored.repository.KanbanRepository
import com.kanbored.kanbored.utils.emptyTask
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class TaskViewModel @Inject constructor(
    connectivityListener: ConnectivityListener,
    private val repository: KanbanRepository,
    private val appEventBus: AppEventBus,
) : BaseViewModel(connectivityListener) {

    private suspend fun refreshSubtasksAndCommentsSync(taskId: Int) {
        val result = repository.refreshSubtasks(taskId)
        when (result) {
            is Result.Error<*> -> {
                appEventBus.emit(AppUiEvent.ShowError(result.message!!))
            }

            is Result.Success<*> -> {}
        }
        val resultTasks = repository.refreshComments(taskId)
        when (resultTasks) {
            is Result.Error<*> -> {
                appEventBus.emit(AppUiEvent.ShowError(result.message!!))
            }

            is Result.Success<*> -> {}
        }
        println("finish refresh subtasks and comments")
    }

    fun refreshSubtasksAndComments(taskId: Int) = viewModelScope.launch {
        refreshSubtasksAndCommentsSync(taskId)
    }

    fun getTask(projectId: Int, columnId: Int, taskId: Int): Flow<KanbanTask> {
        return repository.getTask(projectId, columnId, taskId).map { it ?: emptyTask }
    }

    fun getSubtasks(taskId: Int): Flow<List<KanbanSubtask>> {
        return repository.getSubtasks(taskId)
    }

    fun getComments(taskId: Int): Flow<List<KanbanComment>> {
        return repository.getComments(taskId)
    }

    fun updateTask(task: KanbanTask) = viewModelScope.launch {
        repository.updateTask(task)
    }

    fun deleteTask(task: KanbanTask) = viewModelScope.launch {
        repository.deleteTask(task)
    }
}