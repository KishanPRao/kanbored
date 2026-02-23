package com.kanbored.kanbored.ui.theme

import androidx.compose.runtime.compositionLocalOf
import androidx.compose.ui.graphics.Color

val Primary = Color(0xFF4A58B4)
val OnPrimary = Color(0xFFFFFFFF)
val PrimaryContainer = Color(0xFFBBC0E6)
val OnPrimaryContainer = Color(0xFF151933)
val Secondary = Color(0xFF5B5E70)
val OnSecondary = Color(0xFFFFFFFF)
val SecondaryContainer = Color(0xFFDCD8E6)
val OnSecondaryContainer = Color(0xFF2C2933)
val Tertiary = Color(0xFF7D5260)
val OnTertiary = Color(0xFFFFFFFF)
val TertiaryContainer = Color(0xFFE6CDD5)
val OnTertiaryContainer = Color(0xFF332227)
val Error = Color(0xFFB3261E)
val OnError = Color(0xFFFFFFFF)
val ErrorContainer = Color(0xFFE6ACA9)
val OnErrorContainer = Color(0xFF330B09)
val Background = Color(0xFFfcfcfc)
val OnBackground = Color(0xFF313233)
val Surface = Color(0xFFE7E7E7)
val OnSurface = Color(0xFF313233)
val SurfaceVariant = Color(0xFFdddee6)
val OnSurfaceVariant = Color(0xFF5a5c66)
val Outline = Color(0xFF878999)

val PrimaryDark = Color(0xFFA9B1E6)
val OnPrimaryDark = Color(0xFF1F254C)
val PrimaryContainerDark = Color(0xFF2A3266)
val OnPrimaryContainerDark = Color(0xFFBBC0E6)
val SecondaryDark = Color(0xFFD8D2E6)
val OnSecondaryDark = Color(0xFF433E4C)
val SecondaryContainerDark = Color(0xFF595366)
val OnSecondaryContainerDark = Color(0xFFDCD8E6)
val TertiaryDark = Color(0xFFE6C3CE)
val OnTertiaryDark = Color(0xFF4C323B)
val TertiaryContainerDark = Color(0xFF66434F)
val OnTertiaryContainerDark = Color(0xFFE6CDD5)
val ErrorDark = Color(0xFFE69490)
val OnErrorDark = Color(0xFF4C100D)
val ErrorContainerDark = Color(0xFF661511)
val OnErrorContainerDark = Color(0xFFE6ACA9)
val BackgroundDark = Color(0xFF313233)
val OnBackgroundDark = Color(0xFFe3e4e6)
val SurfaceDark = Color(0xFF28292A)
val OnSurfaceDark = Color(0xFFe3e4e6)
val SurfaceVariantDark = Color(0xFF5a5c66)
val OnSurfaceVariantDark = Color(0xFFd9dbe6)
val OutlineDark = Color(0xFFa5a7b3)

data class KanbanColors(
    val showArchived: Color = Color.Unspecified,
)

val lightKanbanColors = KanbanColors(
    showArchived = Color(0xFFD2C41E)
)

val darkKanbanColors = KanbanColors(
    showArchived = Color(0xFFFFEB3B)
)


val LocalColors = compositionLocalOf { KanbanColors() }