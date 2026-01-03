package com.kanbored.kanbored.utils

import kotlin.time.Clock
import kotlin.time.ExperimentalTime

@OptIn(ExperimentalTime::class)
fun getTimestampInSec(): Long {
    return Clock.System.now().epochSeconds
}

@OptIn(ExperimentalTime::class)
fun getTimestampInMs(): Long {
    return Clock.System.now().toEpochMilliseconds()
}