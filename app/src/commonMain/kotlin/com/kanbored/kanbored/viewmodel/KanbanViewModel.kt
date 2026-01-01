package com.kanbored.kanbored.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.kanbored.kanbored.event.AppEventBus
import com.kanbored.kanbored.event.AppUiEvent
import com.kanbored.kanbored.event.UiEvent
import com.kanbored.kanbored.model.KanbanColumn
import com.kanbored.kanbored.model.KanbanProject
import com.kanbored.kanbored.model.KanbanTask
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
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class KanbanViewModel @Inject constructor(
    private val repository: KanbanRepository,
    private val appEventBus: AppEventBus,
) : ViewModel() {
    private val _uiEventFlow = MutableSharedFlow<UiEvent>()
    val uiEventFlow = _uiEventFlow.asSharedFlow()
    val isApiReachable = repository.pollApiReachability()
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
        println("finish refresh columns and tasks")
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

    fun refreshColumnsAndTasks(projectId: Int, isArchived: Boolean) = viewModelScope.launch {
        _uiEventFlow.emit(UiEvent.ShowLoading)
        refreshColumnsAndTasksSync(projectId, isArchived)
        _uiEventFlow.emit(UiEvent.HideLoading)
    }

    fun createProject(name: String) = viewModelScope.launch {
        val result = repository.createProject(name)
        when (result) {
            is Result.Error<*> -> {
                appEventBus.emit(AppUiEvent.ShowError(result.message!!))
            }

            is Result.Success<*> -> {
                println("created")
                refreshProjectsSync()
            }
        }
    }

    fun createColumn(projectId: Int, name: String) = viewModelScope.launch {
//        val result = repository.createProject(name)
//        when (result) {
//            is Result.Error<*> -> {
//                appEventBus.emit(AppUiEvent.ShowError(result.message!!))
//            }
//
//            is Result.Success<*> -> {
//                println("created")
//                refreshProjectsSync()
//            }
//        }
    }

    fun getColumns(projectId: Int): Flow<List<KanbanColumn>> {
        return repository.getColumns(projectId)
    }

    fun getTasks(projectId: Int, columnId: Int): Flow<List<KanbanTask>> {
        return repository.getTasks(projectId, columnId)
    }

    fun getProject(projectId: Int): KanbanProject {
        return projects.value.find { project -> project.id == projectId } ?: emptyProject
    }

    fun showUiMessage(presentableText: PresentableText) {
        viewModelScope.launch {
            _uiEventFlow.emit(UiEvent.ShowMessage(presentableText))
        }
    }
}