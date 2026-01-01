package com.kanbored.kanbored.screen

import kotlinx.serialization.Serializable

@Serializable
sealed interface Route {
    @Serializable
    object Login : Route

    @Serializable
    object Home : Route

    @Serializable
    data class Project(val projectId: Int) : Route
}