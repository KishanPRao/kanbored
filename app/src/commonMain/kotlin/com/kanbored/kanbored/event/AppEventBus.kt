package com.kanbored.kanbored.event

import com.kanbored.kanbored.utils.PresentableText
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.asSharedFlow
import javax.inject.Inject
import javax.inject.Singleton

sealed interface AppUiEvent {
    class ShowMessage(val message: PresentableText) : AppUiEvent
    class ShowError(val message: PresentableText) : AppUiEvent
    object ShowGlobalLoading : AppUiEvent
    object HideGlobalLoading : AppUiEvent
}

@Singleton
class AppEventBus @Inject constructor() {
    private val _events = MutableSharedFlow<AppUiEvent>()
    val events = _events.asSharedFlow()

    suspend fun emit(event: AppUiEvent) {
        _events.emit(event)
    }
}