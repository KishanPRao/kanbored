package com.kanbored.kanbored.model

data class AuthConfig(
    val baseUrl: String,
    val username: String,
    val password: String,
    val authenticated: Boolean
)