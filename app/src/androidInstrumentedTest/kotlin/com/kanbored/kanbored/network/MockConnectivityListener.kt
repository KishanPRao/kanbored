package com.kanbored.kanbored.network

import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class MockConnectivityListener @Inject constructor() : ConnectivityListener {
    private val _isApiReachable = MutableStateFlow(false)

    fun setReachability(reachable: Boolean) {
        _isApiReachable.value = reachable
    }

    override val isApiReachable: StateFlow<Boolean> = _isApiReachable.asStateFlow()
}