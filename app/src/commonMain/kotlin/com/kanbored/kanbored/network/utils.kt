package com.kanbored.kanbored.network

import kotlinx.serialization.ExperimentalSerializationApi
import kotlinx.serialization.json.ClassDiscriminatorMode
import kotlinx.serialization.json.Json
import kotlinx.serialization.modules.SerializersModule
import kotlinx.serialization.modules.polymorphic
import kotlinx.serialization.modules.subclass

@OptIn(ExperimentalSerializationApi::class)
fun createJson(): Json {
    val module = SerializersModule {
        polymorphic(KanbanRequest::class) {
            subclass(KanbanParamsRequest::class)
            subclass(KanbanArrayRequest::class)
        }
    }
    return Json {
        serializersModule = module
        prettyPrint = false
        ignoreUnknownKeys = true
        encodeDefaults = true
        explicitNulls = false
        classDiscriminatorMode = ClassDiscriminatorMode.NONE
    }
}