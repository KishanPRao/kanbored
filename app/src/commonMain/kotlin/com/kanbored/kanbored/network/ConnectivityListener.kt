package com.kanbored.kanbored.network

import kotlinx.coroutines.flow.Flow

interface ConnectivityListener {
    fun observeStatus(): Flow<NetworkStatus>

}

enum class NetworkStatus {
    Available, Unavailable
}