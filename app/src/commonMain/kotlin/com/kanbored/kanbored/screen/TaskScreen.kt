package com.kanbored.kanbored.screen

import android.R.attr.x
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.lazy.rememberLazyListState
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.PlaylistAdd
import androidx.compose.material.icons.filled.Archive
import androidx.compose.material.icons.filled.Edit
import androidx.compose.material.icons.filled.EditNote
import androidx.compose.material.icons.filled.Unarchive
import androidx.compose.material.icons.rounded.DragHandle
import androidx.compose.material3.Checkbox
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.LocalContentColor
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.hapticfeedback.HapticFeedbackType
import androidx.compose.ui.platform.LocalHapticFeedback
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.AndroidUiModes.UI_MODE_NIGHT_YES
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import com.kanbored.kanbored.model.KanbanComment
import com.kanbored.kanbored.model.KanbanSubtask
import com.kanbored.kanbored.model.KanbanSubtaskFinished
import com.kanbored.kanbored.model.KanbanSubtaskTodo
import com.kanbored.kanbored.model.KanbanTask
import com.kanbored.kanbored.ui.theme.AppTheme
import com.kanbored.kanbored.ui.theme.LocalDimensions
import com.kanbored.kanbored.utils.KanbanIconButton
import com.kanbored.kanbored.utils.PresentableText
import com.kanbored.kanbored.utils.emptyTask
import com.kanbored.kanbored.viewmodel.KanbanViewModel
import com.kanbored.kanbored.viewmodel.TopBarAction
import com.kanbored.kanbored.viewmodel.TopBarDropdownItem
import com.kanbored.kanbored.viewmodel.TopBarViewModel
import com.mikepenz.markdown.m3.Markdown
import com.mikepenz.markdown.m3.markdownColor
import kanbored.app.generated.resources.Res
import kanbored.app.generated.resources.archive
import kanbored.app.generated.resources.comments
import kanbored.app.generated.resources.delete
import kanbored.app.generated.resources.edit
import kanbored.app.generated.resources.empty_task_description
import kanbored.app.generated.resources.rename
import kanbored.app.generated.resources.reorder
import kanbored.app.generated.resources.subtasks
import kanbored.app.generated.resources.topbar_add_checklist
import kanbored.app.generated.resources.unarchive
import org.jetbrains.compose.resources.stringResource
import sh.calvin.reorderable.ReorderableItem
import sh.calvin.reorderable.rememberReorderableLazyListState

@Composable
fun TaskScreen(
    topBarVM: TopBarViewModel,
    kanbanVM: KanbanViewModel,
    projectId: Int,
    columnId: Int,
    taskId: Int,
    modifier: Modifier = Modifier
) {
    kanbanVM.refreshSubtasksAndComments(taskId)
    var isArchived by remember { mutableStateOf(false) }
    val kanbanTask: KanbanTask? by kanbanVM.getTask(
        projectId = projectId,
        columnId = columnId,
        taskId = taskId
    ).collectAsStateWithLifecycle(null)
    val subtasks: List<KanbanSubtask> by kanbanVM.getSubtasks(taskId)
        .collectAsStateWithLifecycle(emptyList())
    val comments: List<KanbanComment> by kanbanVM.getComments(taskId)
        .collectAsStateWithLifecycle(emptyList())
    val task = kanbanTask ?: emptyTask
    var rawMarkdown by remember { mutableStateOf("") }
    LaunchedEffect(task) {
        topBarVM.pushState()
        topBarVM.updateTitle(task.title)
        topBarVM.showBackButton(true)
        topBarVM.setDropdownItems(
            listOf(
                TopBarDropdownItem(PresentableText.DynamicResource(Res.string.rename)) {
                    println("Rename")
                },
                TopBarDropdownItem(PresentableText.DynamicResource(Res.string.delete)) {
                    println("Delete")
                },
            )
        )
        rawMarkdown = task.description.trimIndent()
    }
    topBarVM.setActions(
        listOf(
            TopBarAction(
                icon = Icons.AutoMirrored.Filled.PlaylistAdd,
                contentDescription = PresentableText.DynamicResource(Res.string.topbar_add_checklist),
                onClick = {
                    println("Add a new checklist")
                }
            ),
            TopBarAction(
                icon = if (isArchived) Icons.Filled.Unarchive else Icons.Filled.Archive,
                contentDescription = PresentableText.DynamicResource(
                    if (isArchived) Res.string.unarchive else Res.string.archive
                ),
                onClick = {
                    println("Un/Archive task")
                }
            ),
        ))
    // TODO: Use single LazyColumn, avoid nesting, item/items(..) multiple times instead
    Column(modifier = modifier) {
        TaskDescription(rawMarkdown)
        TaskSubtasks(subtasks)
        TaskComments(comments)
    }
}

@Composable
fun TaskDescription(description: String, modifier: Modifier = Modifier) {
    // TODO: is this the best way?
    var rawMarkdown = description
    var isRawText by remember { mutableStateOf(false) }
    LocalDimensions.current
    Box(modifier = modifier) {
        if (isRawText) {
            RawMarkdownEditor(
                markdown = rawMarkdown,
                onMarkdownChange = { rawMarkdown = it },
                modifier = Modifier
                    .fillMaxWidth()
//                    .defaultMinSize(minHeight = dimensions.minTaskDescHeight)
                    .padding(16.dp)
                    .background(MaterialTheme.colorScheme.surfaceContainer)
            )
        } else {
            Markdown(
                content = rawMarkdown.ifEmpty { stringResource(Res.string.empty_task_description) },
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(6.dp)
                    .background(MaterialTheme.colorScheme.surfaceContainer)
                    // TODO: need more spacing instead
//                    .defaultMinSize(minHeight = dimensions.minTaskDescHeight)
                    .padding(10.dp)
                    .verticalScroll(rememberScrollState()),
                colors = markdownColor(text = if (rawMarkdown.isEmpty()) MaterialTheme.colorScheme.onPrimaryContainer else MaterialTheme.colorScheme.onSurface)
            )
        }
        KanbanIconButton(
            if (isRawText) Icons.Filled.EditNote else Icons.Filled.Edit,
            Res.string.edit,
            tint = if (isRawText) Color.Yellow else LocalContentColor.current,
            modifier = Modifier
                .align(Alignment.TopEnd)
                .padding(10.dp),
        ) {
            isRawText = !isRawText
        }
    }
}

@Composable
fun TaskSubtasks(kanbanSubtasks: List<KanbanSubtask>, modifier: Modifier = Modifier) {
    val hapticFeedback = LocalHapticFeedback.current
    // TODO: best way?
    var subtasks by remember(kanbanSubtasks) { mutableStateOf(kanbanSubtasks.sortedBy { it.position }) }
    val lazyListState = rememberLazyListState()
    val reorderableLazyListState = rememberReorderableLazyListState(lazyListState) { from, to ->
        subtasks = subtasks.toMutableList().apply {
            add(to.index, removeAt(from.index))
        }
        println("re-order subtask: $from => $to")
        hapticFeedback.performHapticFeedback(HapticFeedbackType.SegmentFrequentTick)
    }

    Column(
        modifier = modifier
            .fillMaxWidth()
            .background(MaterialTheme.colorScheme.background)
            .padding(5.dp)
    ) {
        Text(
            text = stringResource(Res.string.subtasks),
            fontWeight = FontWeight.Bold,
        )
        LazyColumn(modifier = modifier.padding(8.dp), state = lazyListState) {
            items(subtasks, key = { it.id }) { subtask ->
                ReorderableItem(reorderableLazyListState, key = subtask.id) { isDragging ->
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Checkbox(subtask.status == KanbanSubtaskFinished, { checked ->
                            val status =
                                if (subtask.status == KanbanSubtaskFinished) KanbanSubtaskTodo else KanbanSubtaskFinished
                            println("Update status: $status")
                            val updatedSubtask = subtask.copy(status = status)
                            subtasks = subtasks.toMutableList().apply {
                                val idx = indexOf(subtask)
                                removeAt(idx)
                                add(idx, updatedSubtask)
                            }
                            // TODO: actually update; avoid just UI update!
                        })
                        Text(subtask.title, modifier = Modifier.weight(1f))
                        IconButton(
                            modifier = Modifier.draggableHandle(
                                onDragStarted = {
                                    hapticFeedback.performHapticFeedback(HapticFeedbackType.GestureThresholdActivate)
                                },
                                onDragStopped = {
                                    hapticFeedback.performHapticFeedback(HapticFeedbackType.GestureEnd)
                                    // TODO: actually update positions
                                },
                            ),
                            onClick = {},
                        ) {
                            Icon(
                                Icons.Rounded.DragHandle,
                                contentDescription = stringResource(Res.string.reorder)
                            )
                        }
                    }
                }
            }
        }
    }
}

@Composable
fun TaskComments(comments: List<KanbanComment>, modifier: Modifier = Modifier) {
    Column(
        modifier = modifier
            .fillMaxWidth()
            .background(MaterialTheme.colorScheme.background)
            .padding(5.dp)
    ) {
        Text(
            text = stringResource(Res.string.comments),
            fontWeight = FontWeight.Bold,
        )
        LazyColumn(modifier = modifier.padding(8.dp)) {
            items(comments) { comment ->
                OutlinedTextField(
                    value = comment.comment,
                    onValueChange = {
                        println("edit comment")
                    },
                    modifier = Modifier
                        .fillMaxWidth()
                        .weight(1f)
                        .padding(5.dp),
                )
            }
        }
    }
}

@Composable
fun RawMarkdownEditor(
    markdown: String,
    onMarkdownChange: (String) -> Unit,
    modifier: Modifier = Modifier
) {
    OutlinedTextField(
        value = markdown,
        onValueChange = onMarkdownChange,
        modifier = modifier,
        placeholder = { Text(stringResource(Res.string.empty_task_description)) },
        textStyle = MaterialTheme.typography.bodyMedium.copy(
            fontFamily = FontFamily.Monospace
        )
    )
}

@Preview(showBackground = true, uiMode = UI_MODE_NIGHT_YES)
@Composable
fun TaskDescEmptyPreview(modifier: Modifier = Modifier) {
    AppTheme(darkTheme = true) {
        Surface {
            TaskDescription("")
        }
    }
}

//@Preview(showBackground = true, uiMode = UI_MODE_NIGHT_YES)
@Composable
fun TaskDescPreview(modifier: Modifier = Modifier) {
    // https://gist.github.com/ww9/44f08d44327a40d2ab309a349bebec57
    AppTheme(darkTheme = true) {
        Surface {
            TaskDescription(
                """
# Gist markdown examples

A collection of Markdown code and tricks that were tested to work in Gist.

This and all public gists in https://gist.github.com/ww9 are [Public Domain](https://en.wikipedia.org/wiki/Public_domain_equivalent_license). Do whatever you want with it including , no need to credit me.

### Todo

- Reformat this whole document and assimilate these:
  - https://gist.github.com/jonschlinkert/5854601
  - https://gist.github.com/ringmatthew/9f7bbfd102003963f9be7dbcf7d40e51
  - https://gist.github.com/DavidWells/7d2e0e1bc78f4ac59a123ddf8b74932d
  - https://gist.github.com/haydenk/958b433ee107537bb166b98b59262b2a
  - https://gist.github.com/asabaylus/3071099
  - https://gist.github.com/t-nissie/9580883 (Add images, secret gists, anti-spam protection)
  - https://guides.github.com/features/mastering-markdown/
  - https://gist.github.com/cyhsutw/d5983d166fb70ff651f027b2aa56ee4e#file-mathjax-ipynb (Python notebook, Math syntax)

##### Table of Contents  
[Headers](#headers)
[Emphasis](#emphasis)
[Lists](#lists)
[Links](#links)
[Images](#images)
[Code and Syntax Highlighting](#code)
[Tables](#tables)
[Blockquotes](#blockquotes)
[Inline HTML](#html)
[Horizontal Rule](#hr)
[Line Breaks](#lines)
[YouTube Videos](#videos)
[TeX Mathematical Formulae](#tex)



### Task lists

```markdown
- [x] Task 1
- [ ] Task 2
- [ ] Task 3
```

Result:

- [x] Task 1
- [ ] Task 2
- [ ] Task 3

### Collapsible content (spoilers)

<details><summaryClick me to expand</summary>

Content between &lt;details&gt; and &lt;/details&gt; is hidden. You need to [escape HTML](https://www.freeformatter.com/html-escape.html) tags them.
  
```python
print("hello world!")
```
</details>

<a name="headers"/>

## Headers

```no-highlight
# H1
## H2
### H3
#### H4
##### H5
###### H6

Alternatively, for H1 and H2, an underline-ish style:

Alt-H1
======

Alt-H2
------
```

# H1
## H2
### H3
#### H4
##### H5
###### H6

Alternatively, for H1 and H2, an underline-ish style:

Alt-H1
======

Alt-H2
------

<a name="emphasis"/>

## Emphasis

```no-highlight
Emphasis, aka italics, with *asterisks* or _underscores_.

Strong emphasis, aka bold, with **asterisks** or __underscores__.

Combined emphasis with **asterisks and _underscores_**.

Strikethrough uses two tildes. ~~Scratch this.~~
```

Emphasis, aka italics, with *asterisks* or _underscores_.

Strong emphasis, aka bold, with **asterisks** or __underscores__.

Combined emphasis with **asterisks and _underscores_**.

Strikethrough uses two tildes. ~~Scratch this.~~


<a name="lists"/>

## Lists

```no-highlight
1. First ordered list item
2. Another item
  * Unordered sub-list. 
1. Actual numbers don't matter, just that it's a number
  1. Ordered sub-list
4. And another item.  
   
   Some text that should be aligned with the above item.

* Unordered list can use asterisks
- Or minuses
+ Or pluses
```

1. First ordered list item
2. Another item
  * Unordered sub-list. 
1. Actual numbers don't matter, just that it's a number
  1. Ordered sub-list
4. And another item.  
   
   Some text that should be aligned with the above item.

* Unordered list can use asterisks
- Or minuses
+ Or pluses

<a name="links"/>

## Links

There are two ways to create links.

```no-highlight
[I'm an inline-style link](https://www.google.com)

[I'm a reference-style link][Arbitrary case-insensitive reference text]

[You can use numbers for reference-style link definitions][1]

Or leave it empty and use the [link text itself]

URLs and URLs in angle brackets will automatically get turned into links. 
http://www.example.com or <http://www.example.com> and sometimes 
example.com (but not on Github, for example).

Some text to show that the reference links can follow later.

[arbitrary case-insensitive reference text]: https://www.mozilla.org
[1]: http://slashdot.org
[link text itself]: http://www.reddit.com
```

[I'm an inline-style link](https://www.google.com)

[I'm a reference-style link][Arbitrary case-insensitive reference text]

[You can use numbers for reference-style link definitions][1]

Or leave it empty and use the [link text itself]

URLs and URLs in angle brackets will automatically get turned into links. 
http://www.example.com or <http://www.example.com> and sometimes 
example.com (but not on Github, for example).

Some text to show that the reference links can follow later.

[arbitrary case-insensitive reference text]: https://www.mozilla.org
[1]: http://slashdot.org
[link text itself]: http://www.reddit.com

<a name="images"/>

## Images

```no-highlight
Here's our logo (hover to see the title text):

Inline-style: 
![alt text](https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png "Logo Title Text 1")

Reference-style: 
![alt text][logo]

[logo]: https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png "Logo Title Text 2"
```

Here's our logo (hover to see the title text):

Inline-style: 
![alt text](https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png "Logo Title Text 1")

Reference-style: 
![alt text][logo]

[logo]: https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png "Logo Title Text 2"

<a name="code"/>

## Code and Syntax Highlighting

Code blocks are part of the Markdown spec, but syntax highlighting isn't. However, many renderers -- like Github's and *Markdown Here* -- support syntax highlighting. *Markdown Here* supports highlighting for dozens of languages (and not-really-languages, like diffs and HTTP headers); to see the complete list, and how to write the language names, see the [highlight.js demo page](http://softwaremaniacs.org/media/soft/highlight/test.html).

```no-highlight
Inline `code` has `back-ticks around` it.
```

Inline `code` has `back-ticks around` it.

Blocks of code are either fenced by lines with three back-ticks <code>```</code>, or are indented with four spaces. I recommend only using the fenced code blocks -- they're easier and only they support syntax highlighting.

<pre lang="no-highlight"><code>```javascript
var s = "JavaScript syntax highlighting";
alert(s);
```
 
```python
s = "Python syntax highlighting"
print s
```
 
```
No language indicated, so no syntax highlighting. 
But let's throw in a &lt;b&gt;tag&lt;/b&gt;.
```
</code></pre>



```javascript
var s = "JavaScript syntax highlighting";
alert(s);
```

```python
s = "Python syntax highlighting"
print s
```

```
No language indicated, so no syntax highlighting in Markdown Here (varies on Github). 
But let's throw in a <b>tag</b>.
```

Again, to see what languages are available for highlighting, and how to write those language names, see the [highlight.js demo page](http://softwaremaniacs.org/media/soft/highlight/test.html).

<a name="tables"/>

## Tables

Tables aren't part of the core Markdown spec, but they are part of GFM and *Markdown Here* supports them. They are an easy way of adding tables to your email -- a task that would otherwise require copy-pasting from another application.

```no-highlight
Colons can be used to align columns.

| Tables        | Are           | Cool  |
| ------------- |:-------------:| -----:|
| col 3 is      | right-aligned | ${'$'}1600 |
| col 2 is      | centered      |   ${'$'}12 |
| zebra stripes | are neat      |    ${'$'}1 |

The outer pipes (|) are optional, and you don't need to make the raw Markdown line up prettily. You can also use inline Markdown.

Markdown | Less | Pretty
--- | --- | ---
*Still* | `renders` | **nicely**
1 | 2 | 3
```

Colons can be used to align columns.

| Tables        | Are           | Cool |
| ------------- |:-------------:| -----:|
| col 3 is      | right-aligned | ${'$'}1600 |
| col 2 is      | centered      |   ${'$'}12 |
| zebra stripes | are neat      |    ${'$'}1 |

The outer pipes (|) are optional, and you don't need to make the raw Markdown line up prettily. You can also use inline Markdown.

Markdown | Less | Pretty
--- | --- | ---
*Still* | `renders` | **nicely**
1 | 2 | 3

<a name="blockquotes"/>

## Blockquotes

```no-highlight
> Blockquotes are very handy in email to emulate reply text.
> This line is part of the same quote.

Quote break.

> This is a very long line that will still be quoted properly when it wraps. Oh boy let's keep writing to make sure this is long enough to actually wrap for everyone. Oh, you can *put* **Markdown** into a blockquote. 
```

> Blockquotes are very handy in email to emulate reply text.
> This line is part of the same quote.

Quote break.

> This is a very long line that will still be quoted properly when it wraps. Oh boy let's keep writing to make sure this is long enough to actually wrap for everyone. Oh, you can *put* **Markdown** into a blockquote. 

<a name="html"/>

## Inline HTML

You can also use raw HTML in your Markdown, and it'll mostly work pretty well. 

```no-highlight
<dl>
  <dt>Definition list</dt>
  <dd>Is something people use sometimes.</dd>

  <dt>Markdown in HTML</dt>
  <dd>Does *not* work **very** well. Use HTML <em>tags</em>.</dd>
</dl>
```

<dl>
  <dt>Definition list</dt>
  <dd>Is something people use sometimes.</dd>

  <dt>Markdown in HTML</dt>
  <dd>Does *not* work **very** well. Use HTML <em>tags</em>.</dd>
</dl>

<a name="hr"/>

## Horizontal Rule

```
Three or more...

---

Hyphens

***

Asterisks

___

Underscores
```

Three or more...

---

Hyphens

***

Asterisks

___

Underscores

<a name="lines"/>

## Line Breaks

My basic recommendation for learning how line breaks work is to experiment and discover -- hit &lt;Enter&gt; once (i.e., insert one newline), then hit it twice (i.e., insert two newlines), see what happens. You'll soon learn to get what you want. "Markdown Toggle" is your friend. 

Here are some things to try out:

```
Here's a line for us to start with.

This line is separated from the one above by two newlines, so it will be a *separate paragraph*.

This line is also a separate paragraph, but...
This line is only separated by a single newline, so it's a separate line in the *same paragraph*.
```

Here's a line for us to start with.

This line is separated from the one above by two newlines, so it will be a *separate paragraph*.

This line is also begins a separate paragraph, but...  
This line is only separated by a single newline, so it's a separate line in the *same paragraph*.

(Technical note: *Markdown Here* uses GFM line breaks, so there's no need to use MD's two-space line breaks.)

<a name="videos"/>

## YouTube Videos

They can't be added directly but you can add an image with a link to the video like this:

```no-highlight
<a href="http://www.youtube.com/watch?feature=player_embedded&v=YOUTUBE_VIDEO_ID_HERE
" target="_blank"><img src="http://img.youtube.com/vi/YOUTUBE_VIDEO_ID_HERE/0.jpg" 
alt="IMAGE ALT TEXT HERE" width="240" height="180" border="10" /></a>
```

Or, in pure Markdown, but losing the image sizing and border:

```no-highlight
[![IMAGE ALT TEXT HERE](http://img.youtube.com/vi/YOUTUBE_VIDEO_ID_HERE/0.jpg)](http://www.youtube.com/watch?v=YOUTUBE_VIDEO_ID_HERE)
```

<a name="tex"/>

## TeX Mathematical Formulae

A full description of TeX math symbols is beyond the scope of this cheatsheet. Here's a [good reference](https://en.wikibooks.org/wiki/LaTeX/Mathematics), and you can try stuff out on [CodeCogs](https://www.codecogs.com/latex/eqneditor.php). You can also play with formulae in the Markdown Here options page.

Here are some examples to try out:

```
${'$'}-b \pm \sqrt{b^2 - 4ac} \over 2a${'$'}
$x = a_0 + \frac{1}{a_1 + \frac{1}{a_2 + \frac{1}{a_3 + a_4}}}${'$'}
${'$'}\forall x \in X, \quad \exists y \leq \epsilon${'$'}
```

The beginning and ending dollar signs (`${'$'}`) are the delimiters for the TeX markup.
        """
            )
        }
    }
}

@Preview(showBackground = true, uiMode = UI_MODE_NIGHT_YES)
@Composable
fun TaskSubtasksPreview(modifier: Modifier = Modifier) {
    AppTheme(darkTheme = true) {
        Surface {
            val subtasks = List(5) { idx ->
                val chars = ('a'..'z') + ('A'..'Z') + ('0'..'9')
                val randomStr = List(8) { chars.random().toString() }.joinToString("")
                KanbanSubtask(
                    idx,
                    title = randomStr,
                    status = 0,
                    timeEstimated = 0,
                    timeSpent = 0,
                    taskId = 0,
                    userId = 0,
                    position = idx,
                    username = "",
                    name = "",
                    timerStartDate = 0,
                    statusName = "",
                    isTimerStarted = false,
                )
            }
            TaskSubtasks(subtasks)
        }
    }
}

@Preview(showBackground = true, uiMode = UI_MODE_NIGHT_YES)
@Composable
fun TaskCommentsPreview(modifier: Modifier = Modifier) {
    AppTheme(darkTheme = true) {
        Surface {
            val comments = List(5) { idx ->
                val chars = ('a'..'z') + ('A'..'Z') + ('0'..'9')
                val randomStr = List(30) { chars.random().toString() }.joinToString("")
                KanbanComment(
                    idx,
                    dateCreation = 0,
                    dateModification = 0,
                    taskId = 0,
                    userId = 0,
                    comment = randomStr,
                    username = "",
                    name = "",
                    email = "",
                    avatarPath = "",
                )
            }
            TaskComments(comments)
        }
    }
}