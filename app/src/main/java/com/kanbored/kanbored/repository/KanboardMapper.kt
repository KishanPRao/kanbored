//package com.kanbored.kanbored.repository
//
//import com.kanbored.kanbored.model.KanbanUserSession
//import com.kanbored.kanbored.persistent.KanbanUserSessionEntity
//
//fun KanbanUserSession.toEntity(): KanbanUserSessionEntity =
//    KanbanUserSessionEntity(
//        userId = userId,
//        userName = userName,
//        password = password,
//        hostUrl = hostUrl,
//        appRole = appRole,
//        authenticated = authenticated,
//    )
//
//fun KanbanUserSessionEntity.toModel(): KanbanUserSession =
//    KanbanUserSession(
//        userId = userId,
//        userName = userName,
//        password = password,
//        hostUrl = hostUrl,
//        appRole = appRole,
//        authenticated = authenticated,
//    )