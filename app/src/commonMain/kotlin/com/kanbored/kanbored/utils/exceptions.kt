package com.kanbored.kanbored.utils

class InvalidCredentialsException : IllegalStateException()

class ApiFailedException(override val message: String?) : RuntimeException()

class InvalidResponseException(override val message: String?) : RuntimeException()