package com.kanbored.kanbored.viewmodel

import co.touchlab.kermit.Logger
import com.kanbored.kanbored.event.AppEventBus
import com.kanbored.kanbored.event.AppUiEvent
import com.kanbored.kanbored.event.UiEvent
import com.kanbored.kanbored.model.KanbanColumn
import com.kanbored.kanbored.model.KanbanProject
import com.kanbored.kanbored.model.KanbanTask
import com.kanbored.kanbored.network.ConnectivityListener
import com.kanbored.kanbored.network.Result
import com.kanbored.kanbored.repository.KanbanRepository
import com.kanbored.kanbored.utils.emptyProject
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import javax.inject.Inject

// TODO: rename (also "project screen")
@HiltViewModel
class ProjectViewModel @Inject constructor(
    connectivityListener: ConnectivityListener,
    private val repository: KanbanRepository,
    private val appEventBus: AppEventBus,
) : BaseViewModel(connectivityListener) {

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

    fun refreshColumns(projectId: Int) = backgroundCall {
        _uiEventFlow.emit(UiEvent.ShowLoading)
        refreshColumnsSync(projectId)
        _uiEventFlow.emit(UiEvent.HideLoading)
    }

    fun refreshColumnsAndTasks(projectId: Int, isArchived: Boolean, showRefresh: Boolean = true) =
        backgroundCall {
//            Exception().printStackTrace()
            Logger.v("refreshColumnsAndTasks: $projectId")
            if (showRefresh) _uiEventFlow.emit(UiEvent.ShowLoading)
            refreshColumnsAndTasksSync(projectId, isArchived)
            if (showRefresh) _uiEventFlow.emit(UiEvent.HideLoading)
        }

    fun getProject(projectId: Int): Flow<KanbanProject> {
        return repository.getProject(projectId).map { it ?: emptyProject }
    }

    fun getColumns(projectId: Int, isArchived: Boolean): Flow<List<KanbanColumn>> {
        return repository.getColumns(projectId, isArchived)
    }

    fun getTasks(projectId: Int, columnId: Int, isArchived: Boolean): Flow<List<KanbanTask>> {
        return repository.getTasks(projectId, columnId, isArchived)
    }

    fun createColumn(projectId: Int, name: String) = backgroundCall {
        repository.createColumn(projectId, name)
    }

    fun createTask(projectId: Int, columnId: Int, name: String) = backgroundCall {
        repository.createTask(projectId, columnId, name)
    }

    fun updateProject(project: KanbanProject) = backgroundCall {
        repository.updateProject(project)
    }

    fun updateColumn(column: KanbanColumn) = backgroundCall {
        repository.updateColumn(column)
    }

    fun enableProject(project: KanbanProject) = backgroundCall {
        repository.enableProject(project)
    }

    // TODO: decide if archiving project, applies "inactive" status to all nested items; clear language/workflow
    fun disableProject(project: KanbanProject) = backgroundCall {
        repository.disableProject(project)
    }

    fun deleteProject(project: KanbanProject) = backgroundCall {
        repository.deleteProject(project)
    }
}