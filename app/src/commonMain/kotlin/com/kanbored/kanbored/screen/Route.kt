package com.kanbored.kanbored.screen

import kotlinx.serialization.Serializable

sealed class Route {
    @Serializable
    object Login : Route()

    @Serializable
    object Home : Route()
}