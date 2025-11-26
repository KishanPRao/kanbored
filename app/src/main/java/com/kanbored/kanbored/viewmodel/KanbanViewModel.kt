package com.kanbored.kanbored.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.kanbored.kanbored.model.KanbanUserSession
import com.kanbored.kanbored.network.Result
import com.kanbored.kanbored.repository.KanbanRepository
import com.kanbored.kanbored.utils.PresentableText
import com.kanbored.kanbored.utils.UiEvent
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asSharedFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

class KanbanViewModel(val repository: KanbanRepository) : ViewModel() {
    private val _authenticatedSession: MutableStateFlow<KanbanUserSession?> =
        MutableStateFlow(value = null)
    private val _uiEventFlow = MutableSharedFlow<UiEvent>()

    val authenticatedSession = _authenticatedSession.asStateFlow()
    val uiEventFlow = _uiEventFlow.asSharedFlow()

    fun login(
        hostUrl: String,
        userName: String,
        password: String
    ) {
        viewModelScope.launch {
            _uiEventFlow.emit(UiEvent.ShowLoading)
            println("login view model")
            val result = repository.login(
                hostUrl = hostUrl,
                userName = userName,
                password = password,
            )
            _uiEventFlow.emit(UiEvent.HideLoading)
            when (result) {
                is Result.Error<*> -> {
                    _uiEventFlow.emit(UiEvent.ShowMessage(result.message!!))
                }
                is Result.Success<*> -> {
                    _authenticatedSession.value = result.data!!
                }
            }
        }
    }

    fun showUiMessage(presentableText: PresentableText) {
        viewModelScope.launch {
            _uiEventFlow.emit(UiEvent.ShowMessage(presentableText))
        }
    }
}