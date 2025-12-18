package com.kanbored.kanbored.event

import com.kanbored.kanbored.utils.PresentableText

sealed interface UiEvent {
    class ShowMessage(val message: PresentableText) : UiEvent
    object ShowLoading : UiEvent
    object HideLoading : UiEvent
}