package com.kanbored.kanbored.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.kanbored.kanbored.network.Result
import com.kanbored.kanbored.usecase.LoginUseCase
import com.kanbored.kanbored.utils.AppEventBus
import com.kanbored.kanbored.utils.AppUiEvent
import com.kanbored.kanbored.utils.PresentableText
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class LoginViewModel @Inject constructor(
    private val loginUseCase: LoginUseCase,
    private val appEventBus: AppEventBus,
) : ViewModel() {

    fun login(
        baseUrl: String,
        userName: String,
        password: String
    ) {
        viewModelScope.launch {
            appEventBus.emit(AppUiEvent.ShowGlobalLoading)
            println("login view model")
            val result = loginUseCase(
                baseUrl = baseUrl,
                userName = userName,
                password = password,
            )
            appEventBus.emit(AppUiEvent.HideGlobalLoading)
            when (result) {
                is Result.Error<*> -> {
                    appEventBus.emit(AppUiEvent.ShowError(result.message!!))
                }

                is Result.Success<*> -> {}
            }
        }
    }

    fun showUiMessage(presentableText: PresentableText) {
        viewModelScope.launch {
            appEventBus.emit(AppUiEvent.ShowMessage(presentableText))
        }
    }
}