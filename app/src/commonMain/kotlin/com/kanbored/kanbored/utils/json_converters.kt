package com.kanbored.kanbored.utils

import androidx.room.TypeConverter
import com.kanbored.kanbored.network.KanbanMethod
import com.kanbored.kanbored.network.KanbanParams
import kotlinx.serialization.KSerializer
import kotlinx.serialization.descriptors.PrimitiveKind
import kotlinx.serialization.descriptors.PrimitiveSerialDescriptor
import kotlinx.serialization.descriptors.SerialDescriptor
import kotlinx.serialization.encoding.Decoder
import kotlinx.serialization.encoding.Encoder
import kotlinx.serialization.json.Json

object BooleanAsIntSerializer : KSerializer<Boolean> {
    override val descriptor: SerialDescriptor =
        PrimitiveSerialDescriptor("BooleanAsInt", PrimitiveKind.INT)

    override fun serialize(encoder: Encoder, value: Boolean) {
        encoder.encodeInt(if (value) 1 else 0)
    }

    override fun deserialize(decoder: Decoder): Boolean {
        return decoder.decodeInt() != 0
    }
}

class KanbanParamsConverter {
    @TypeConverter
    fun fromCustomObject(value: KanbanParams): String = Json.encodeToString(value)

    @TypeConverter
    fun toCustomObject(value: String): KanbanParams = Json.decodeFromString(value)
}

class KanbanMethodConverter {
    @TypeConverter
    fun fromCustomObject(value: KanbanMethod): String = Json.encodeToString(value)

    @TypeConverter
    fun toCustomObject(value: String): KanbanMethod = Json.decodeFromString(value)
}