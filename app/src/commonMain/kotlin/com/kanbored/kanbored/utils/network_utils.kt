package com.kanbored.kanbored.utils

import kotlinx.serialization.ExperimentalSerializationApi
import kotlinx.serialization.json.ClassDiscriminatorMode
import kotlinx.serialization.json.Json

@OptIn(ExperimentalSerializationApi::class)
fun createJson(): Json {
    return Json {
        prettyPrint = false
        ignoreUnknownKeys = true
        encodeDefaults = true
        explicitNulls = false
        classDiscriminatorMode = ClassDiscriminatorMode.NONE
    }
}