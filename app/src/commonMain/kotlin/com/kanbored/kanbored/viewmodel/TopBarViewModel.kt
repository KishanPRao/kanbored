package com.kanbored.kanbored.viewmodel

import androidx.compose.ui.graphics.vector.ImageVector
import androidx.lifecycle.ViewModel
import com.kanbored.kanbored.utils.PresentableText
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import javax.inject.Inject

@HiltViewModel
class TopBarViewModel @Inject constructor() : ViewModel() {
    private val _state = MutableStateFlow(TopBarState())
    private var _backupState: TopBarState? = null

    val state: StateFlow<TopBarState> = _state.asStateFlow()

    fun updateTitle(title: String) {
        _state.update { it.copy(title = title) }
    }

    fun showBackButton(show: Boolean) {
        _state.update { it.copy(showBackButton = show) }
    }

    fun setActions(actions: List<TopBarAction>) {
        _state.update { it.copy(actions = actions) }
    }

    fun setDropdownItems(items: List<TopBarDropdownItem>) {
        _state.update { it.copy(dropdownItems = items) }
    }

    fun saveState() {
        _backupState = _state.value
    }

    fun revertState() {
        _backupState?.let { state ->
            _state.update { state }
            _backupState = null
        }
    }
}

data class TopBarState(
    val title: String = "",
    val showBackButton: Boolean = false,
    val actions: List<TopBarAction> = emptyList(),
    val dropdownItems: List<TopBarDropdownItem> = emptyList(),
)

data class TopBarAction(
    val icon: ImageVector,
    val contentDescription: PresentableText,
    val onClick: () -> Unit
)

data class TopBarDropdownItem(
    val contentDescription: PresentableText,
    val onClick: () -> Unit
)