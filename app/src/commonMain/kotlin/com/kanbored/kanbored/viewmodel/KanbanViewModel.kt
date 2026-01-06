package com.kanbored.kanbored.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import co.touchlab.kermit.Logger
import com.kanbored.kanbored.event.AppEventBus
import com.kanbored.kanbored.event.AppUiEvent
import com.kanbored.kanbored.event.UiEvent
import com.kanbored.kanbored.model.KanbanColumn
import com.kanbored.kanbored.model.KanbanComment
import com.kanbored.kanbored.model.KanbanProject
import com.kanbored.kanbored.model.KanbanSubtask
import com.kanbored.kanbored.model.KanbanTask
import com.kanbored.kanbored.network.ConnectivityListener
import com.kanbored.kanbored.network.Result
import com.kanbored.kanbored.repository.KanbanRepository
import com.kanbored.kanbored.utils.PresentableText
import com.kanbored.kanbored.utils.emptyProject
import com.kanbored.kanbored.utils.refreshStateDelay
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asSharedFlow
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class KanbanViewModel @Inject constructor(
    connectivityListener: ConnectivityListener,
    private val repository: KanbanRepository,
    private val appEventBus: AppEventBus,
) : ViewModel() {
    private val _uiEventFlow = MutableSharedFlow<UiEvent>()
    val uiEventFlow = _uiEventFlow.asSharedFlow()
    val isApiReachable = connectivityListener.isApiReachable
    val projects: StateFlow<List<KanbanProject>> = repository.getAllProjects()
        .stateIn(
            scope = viewModelScope,
            started = SharingStarted.WhileSubscribed(stopTimeoutMillis = 5_000),
            initialValue = emptyList()
        )

    init {
        viewModelScope.launch {
            startAutoRefresh()
        }
    }

    private suspend fun startAutoRefresh() {
        while (true) {
            refreshProjectsSync()
            for (project in projects.value) {
                Logger.d("proj: ${project.id}, ${project.name}")
                refreshColumnsAndTasks(project.id, false)
                refreshColumnsAndTasks(project.id, true)
            }
            delay(refreshStateDelay)
        }
    }

    private suspend fun refreshProjectsSync() {
        val result = repository.refreshProjects()
        println("finish refresh project")
        when (result) {
            is Result.Error<*> -> {
                appEventBus.emit(AppUiEvent.ShowError(result.message!!))
            }

            is Result.Success<*> -> {}
        }
    }

    private suspend fun refreshColumnsSync(projectId: Int) {
        val result = repository.refreshColumns(projectId)
        println("finish refresh columns")
        when (result) {
            is Result.Error<*> -> {
                appEventBus.emit(AppUiEvent.ShowError(result.message!!))
            }

            is Result.Success<*> -> {}
        }
    }

    private suspend fun refreshColumnsAndTasksSync(projectId: Int, isArchived: Boolean) {
        val result = repository.refreshColumns(projectId)
        when (result) {
            is Result.Error<*> -> {
                appEventBus.emit(AppUiEvent.ShowError(result.message!!))
            }

            is Result.Success<*> -> {}
        }
        val resultTasks = repository.refreshTasks(projectId, isArchived)
        when (resultTasks) {
            is Result.Error<*> -> {
                appEventBus.emit(AppUiEvent.ShowError(result.message!!))
            }

            is Result.Success<*> -> {}
        }
//        println("finish refresh columns and tasks")
    }

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

    fun refreshProjects() = viewModelScope.launch {
        _uiEventFlow.emit(UiEvent.ShowLoading)
        refreshProjectsSync()
        _uiEventFlow.emit(UiEvent.HideLoading)
    }

    fun refreshAllColumns() = viewModelScope.launch {
        _uiEventFlow.emit(UiEvent.ShowLoading)
        for (project in projects.value) {
            refreshColumnsSync(project.id)
        }
        _uiEventFlow.emit(UiEvent.HideLoading)
    }

    fun refreshColumns(projectId: Int) = viewModelScope.launch {
        _uiEventFlow.emit(UiEvent.ShowLoading)
        refreshColumnsSync(projectId)
        _uiEventFlow.emit(UiEvent.HideLoading)
    }

    fun refreshColumnsAndTasks(projectId: Int, isArchived: Boolean, showRefresh: Boolean = true) =
        viewModelScope.launch {
//            Exception().printStackTrace()
            Logger.d("refreshColumnsAndTasks: $projectId")
            if (showRefresh) _uiEventFlow.emit(UiEvent.ShowLoading)
            refreshColumnsAndTasksSync(projectId, isArchived)
            if (showRefresh) _uiEventFlow.emit(UiEvent.HideLoading)
        }

    fun refreshSubtasksAndComments(taskId: Int) = viewModelScope.launch {
        refreshSubtasksAndCommentsSync(taskId)
    }

    fun getColumns(projectId: Int): Flow<List<KanbanColumn>> {
        return repository.getColumns(projectId)
    }

    fun getTasks(projectId: Int, columnId: Int): Flow<List<KanbanTask>> {
        return repository.getTasks(projectId, columnId)
    }

    fun getSubtasks(taskId: Int): Flow<List<KanbanSubtask>> {
        return repository.getSubtasks(taskId)
    }

    fun getComments(taskId: Int): Flow<List<KanbanComment>> {
        return repository.getComments(taskId)
    }

    fun getProject(projectId: Int): Flow<KanbanProject> {
        return repository.getProject(projectId).map { it ?: emptyProject }
    }

    fun getTask(projectId: Int, columnId: Int, taskId: Int): Flow<KanbanTask?> {
        return repository.getTask(projectId, columnId, taskId)
    }

    fun createProject(name: String) = viewModelScope.launch {
        repository.createProject(name)
    }

    fun createColumn(projectId: Int, name: String) = viewModelScope.launch {
        repository.createColumn(projectId, name)
    }

    fun updateProject(project: KanbanProject) = viewModelScope.launch {
        repository.updateProject(project)
    }

    fun deleteProject(project: KanbanProject) = viewModelScope.launch {
        repository.deleteProject(project)
    }

    fun showUiMessage(presentableText: PresentableText) {
        viewModelScope.launch {
            _uiEventFlow.emit(UiEvent.ShowMessage(presentableText))
        }
    }
}