package com.kanbored.kanbored.repository

import android.content.SharedPreferences
import androidx.core.content.edit
import com.kanbored.kanbored.model.AuthConfig
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import javax.inject.Inject
import javax.inject.Named
import javax.inject.Singleton

@Singleton
class ConfigRepository @Inject constructor(
    @param:Named("secure_prefs") private val prefs: SharedPreferences,
) {
    private val unauthenticatedConfig = AuthConfig(
        "",
        "",
        "",
        false,
    )

    private val _config = MutableStateFlow(loadConfig())
    val config: StateFlow<AuthConfig> = _config.asStateFlow()
    private fun loadConfig(): AuthConfig {
        val baseUrl = prefs.getString("baseUrl", null)
        val username = prefs.getString("username", null)
        val password = prefs.getString("password", null)
        val authenticated = prefs.getBoolean("authenticated", false)
        println("get config: $baseUrl, $username, $password")
        return if (baseUrl != null && username != null && password != null) {
            AuthConfig(baseUrl, username, password, authenticated)
        } else {
            unauthenticatedConfig
        }
    }

    fun saveConfig(
        baseUrl: String,
        username: String,
        password: String,
    ) {
        println("save config: $baseUrl, $username, $password")
        prefs.edit(commit = true) {
            putString("baseUrl", baseUrl)
            putString("username", username)
            putString("password", password)
            putBoolean("authenticated", false)
            println("finished saving!")
        }
        _config.value = AuthConfig(baseUrl, username, password, false)
    }

    fun authenticateConfig() {
        prefs.edit(commit = true) {
            putBoolean("authenticated", true)
            println("finished authenticating")
        }
        _config.value = config.value.copy(authenticated = true)
    }

    fun clearConfig() {
        prefs.edit(commit = true) { clear() }
        _config.value = unauthenticatedConfig
    }
}
