package com.kanbored.kanbored.network

import kotlinx.coroutines.flow.Flow
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class ConnectivityListenerImpl @Inject constructor() : ConnectivityListener {
    // TODO
    override fun observeStatus(): Flow<NetworkStatus> {
        TODO("Not yet implemented")
    }
}