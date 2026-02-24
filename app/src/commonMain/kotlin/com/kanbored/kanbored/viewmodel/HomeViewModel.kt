package com.kanbored.kanbored.viewmodel

import androidx.lifecycle.viewModelScope
import co.touchlab.kermit.Logger
import com.kanbored.kanbored.event.AppEventBus
import com.kanbored.kanbored.event.AppUiEvent
import com.kanbored.kanbored.event.UiEvent
import com.kanbored.kanbored.model.KanbanProject
import com.kanbored.kanbored.network.ConnectivityListener
import com.kanbored.kanbored.network.Result
import com.kanbored.kanbored.repository.KanbanRepository
import com.kanbored.kanbored.utils.refreshStateDelay
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class HomeViewModel @Inject constructor(
    connectivityListener: ConnectivityListener,
    private val repository: KanbanRepository,
    private val appEventBus: AppEventBus,
) : BaseViewModel(connectivityListener) {
    private val _showArchived = MutableStateFlow(false)
    val projects: StateFlow<List<KanbanProject>> = repository.getAllProjects()
        .combine(_showArchived) { list, archived ->
            list.filter { archived != it.isActive }
        }
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
                Logger.v("proj: ${project.id}, ${project.name}")
                refreshColumnsAndTasks(project.id, false)
                refreshColumnsAndTasks(project.id, true)
            }
            delay(refreshStateDelay)
        }
    }

    private suspend fun refreshProjectsSync() {
        val result = repository.refreshProjects()
        Logger.v("finish refresh project")
        when (result) {
            is Result.Error<*> -> {
                appEventBus.emit(AppUiEvent.ShowError(result.message!!))
            }

            is Result.Success<*> -> {}
        }
    }

    private suspend fun refreshColumnsSync(projectId: Int) {
        val result = repository.refreshColumns(projectId)
        Logger.v("finish refresh columns")
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

    fun refreshProjects() = viewModelScope.launch {
        _uiEventFlow.emit(UiEvent.ShowLoading)
        refreshProjectsSync()
        _uiEventFlow.emit(UiEvent.HideLoading)
    }

    fun refreshColumns(projectId: Int) = viewModelScope.launch {
        _uiEventFlow.emit(UiEvent.ShowLoading)
        refreshColumnsSync(projectId)
        _uiEventFlow.emit(UiEvent.HideLoading)
    }

    // TODO: duplicated code across Home & Project VM
    fun refreshColumnsAndTasks(projectId: Int, isArchived: Boolean, showRefresh: Boolean = true) =
        viewModelScope.launch {
//            Exception().printStackTrace()
            Logger.v("refreshColumnsAndTasks: $projectId")
            if (showRefresh) _uiEventFlow.emit(UiEvent.ShowLoading)
            refreshColumnsAndTasksSync(projectId, isArchived)
            if (showRefresh) _uiEventFlow.emit(UiEvent.HideLoading)
        }

    fun showArchivedProjects(showArchived: Boolean) {
        _showArchived.value = showArchived
    }

    fun createProject(name: String) = viewModelScope.launch {
        repository.createProject(name)
    }
}