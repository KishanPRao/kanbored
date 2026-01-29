package com.kanbored.kanbored.network

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.currentCoroutineContext
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.distinctUntilChanged
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.isActive
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class ConnectivityListenerImpl @Inject constructor(
    private val apiProvider: ApiProvider
) : ConnectivityListener {
    companion object {
        const val API_POLL_INTERVAL_MS = 5_000L
    }

    private val scope: CoroutineScope = CoroutineScope(Dispatchers.IO)

    override val isApiReachable: StateFlow<Boolean> = pollApiReachability()

    private fun pollApiReachability(
        intervalMs: Long = API_POLL_INTERVAL_MS
    ): StateFlow<Boolean> {
        return flow {
            while (currentCoroutineContext().isActive) {
                val isReachable: Boolean = apiProvider.isApiReachable()
                emit(isReachable)
                delay(intervalMs)
            }
        }
            .distinctUntilChanged()
            .stateIn(
                scope = scope,
                started = SharingStarted.WhileSubscribed(stopTimeoutMillis = 5_000),
                initialValue = true
            )
    }
}