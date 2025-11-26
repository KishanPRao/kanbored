package com.kanbored.kanbored.network

import com.kanbored.kanbored.utils.PresentableText

sealed class Result<T>(val data: T? = null, val message: PresentableText? = null) {
    class Success<T>(data: T) : Result<T>(data)
    class Error<T>(message: PresentableText, data: T? = null) : Result<T>(data, message)
}