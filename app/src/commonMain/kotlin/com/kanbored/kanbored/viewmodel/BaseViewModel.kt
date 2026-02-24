package com.kanbored.kanbored.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.kanbored.kanbored.event.UiEvent
import com.kanbored.kanbored.network.ConnectivityListener
import com.kanbored.kanbored.utils.PresentableText
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.asSharedFlow
import kotlinx.coroutines.launch

open class BaseViewModel(connectivityListener: ConnectivityListener) : ViewModel() {
    val isApiReachable = connectivityListener.isApiReachable

    @Suppress("PropertyName")
    protected val _uiEventFlow = MutableSharedFlow<UiEvent>()
    val uiEventFlow = _uiEventFlow.asSharedFlow()

    fun showUiMessage(presentableText: PresentableText) {
        viewModelScope.launch {
            _uiEventFlow.emit(UiEvent.ShowMessage(presentableText))
        }
    }

    fun <T> backgroundCall(block: suspend () -> T) = viewModelScope.launch {
        block()
    }
}