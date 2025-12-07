package com.kanbored.kanbored.utils

import com.kanbored.kanbored.BuildConfig

actual object BuildConfiguration {
    actual val isDebug: Boolean = BuildConfig.DEBUG
    actual val buildType: String = BuildConfig.BUILD_TYPE
}