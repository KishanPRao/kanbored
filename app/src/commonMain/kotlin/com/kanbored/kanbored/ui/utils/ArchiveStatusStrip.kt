package com.kanbored.kanbored.ui.utils

import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.core.tween
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.slideInVertically
import androidx.compose.animation.slideOutVertically
import androidx.compose.animation.togetherWith
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import com.kanbored.kanbored.ui.theme.LocalColors

@Composable
fun ArchiveStatusStrip(
    text: String,
    showStrip: Boolean,
) {
    val localColors = LocalColors.current
    val bgColor = localColors.showArchived
    val textColor = localColors.onShowArchived

    AnimatedVisibility(
        visible = showStrip,
        enter = slideInVertically() + fadeIn(),
        exit = slideOutVertically() + fadeOut(
            animationSpec = tween(300)
        )
    ) {
        AnimatedContent(
            targetState = text,
            transitionSpec = {
                fadeIn(animationSpec = tween(500)) togetherWith
                        fadeOut(animationSpec = tween(500))
            },
            label = "archive_strip_anim"
        ) { text ->
            Text(
                text = text,
                modifier = Modifier
                    .fillMaxWidth()
                    .background(bgColor)
                    .padding(5.dp),
                color = textColor,
                textAlign = TextAlign.Center,
                maxLines = 1,
            )
        }
    }
}