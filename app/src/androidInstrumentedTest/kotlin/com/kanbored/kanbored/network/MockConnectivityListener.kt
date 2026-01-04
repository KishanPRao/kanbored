package com.kanbored.kanbored.network

import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class MockConnectivityListener @Inject constructor() : ConnectivityListener {
    private val networkStatusFlow = MutableStateFlow(NetworkStatus.Unavailable)

    override fun observeStatus(): Flow<NetworkStatus> = networkStatusFlow

    fun setNetworkStatus(status: NetworkStatus) {
        networkStatusFlow.value = status
    }
}