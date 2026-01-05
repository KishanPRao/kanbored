package com.kanbored.kanbored.network

import kotlinx.coroutines.flow.StateFlow

interface ConnectivityListener {
    val isApiReachable: StateFlow<Boolean>
}