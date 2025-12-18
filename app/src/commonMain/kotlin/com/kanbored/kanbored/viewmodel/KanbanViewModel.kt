package com.kanbored.kanbored.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.kanbored.kanbored.event.AppEventBus
import com.kanbored.kanbored.event.AppUiEvent
import com.kanbored.kanbored.event.UiEvent
import com.kanbored.kanbored.model.KanbanProject
import com.kanbored.kanbored.network.Result
import com.kanbored.kanbored.repository.KanbanRepository
import com.kanbored.kanbored.utils.PresentableText
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asSharedFlow
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch
import javax.inject.Inject

// 30 seconds
const val refreshStateDelay = 30_000L

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
            delay(refreshStateDelay)
        }
    }

    private suspend fun refreshProjectsSync() {
        _uiEventFlow.emit(UiEvent.ShowLoading)
        val result = repository.refreshProjects()
        println("finish refresh project")
        _uiEventFlow.emit(UiEvent.HideLoading)
        when (result) {
            is Result.Error<*> -> {
                appEventBus.emit(AppUiEvent.ShowError(result.message!!))
            }

            is Result.Success<*> -> {}
        }
    }

    fun refreshProjects() = viewModelScope.launch { refreshProjectsSync() }

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

    fun showUiMessage(presentableText: PresentableText) {
        viewModelScope.launch {
            _uiEventFlow.emit(UiEvent.ShowMessage(presentableText))
        }
    }
}