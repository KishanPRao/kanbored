package com.kanbored.kanbored.utils

sealed interface UiEvent {
    class ShowMessage(val message: PresentableText) : UiEvent
    object ShowGlobalLoading : UiEvent
    object HideGlobalLoading : UiEvent
    object ShowLocalLoading : UiEvent
    object HideLocalLoading : UiEvent
}