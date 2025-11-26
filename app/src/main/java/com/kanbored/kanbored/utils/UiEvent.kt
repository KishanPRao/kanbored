package com.kanbored.kanbored.utils

sealed interface UiEvent {
    class ShowMessage(val message: PresentableText) : UiEvent
    object ShowLoading : UiEvent
    object HideLoading : UiEvent
}