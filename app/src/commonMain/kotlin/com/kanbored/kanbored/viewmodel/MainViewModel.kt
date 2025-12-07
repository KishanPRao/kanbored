package com.kanbored.kanbored.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.kanbored.kanbored.repository.ConfigRepository
import com.kanbored.kanbored.utils.AppEventBus
import com.kanbored.kanbored.utils.AppUiEvent
import com.kanbored.kanbored.utils.PresentableText
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class MainViewModel @Inject constructor(
    configRepository: ConfigRepository,
    val appEventBus: AppEventBus,
) : ViewModel() {

    val authConfig = configRepository.config

    fun showUiMessage(presentableText: PresentableText) {
        viewModelScope.launch {
            appEventBus.emit(AppUiEvent.ShowMessage(presentableText))
        }
    }
}