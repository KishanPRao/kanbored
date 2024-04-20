# kanbored
Kanbored

```
TODO: Remove!
Container(child: Text("TMP"), color: Colors.white,)
SizedBox(width: _columnWidth, child: TextField(decoration: InputDecoration(hintText: "add_task".resc())))
```

Behaviour:
- Archived task & column: viewing archived columns, show all tasks within archived column & show column w/ inactive tasks.
- New Checklist: if no existing checklist (from trello), all existing tasks to new checklist, create a new one.

NOTE: bridge supported features might not look right while using `kanboard`.
Also, `kanboard` features might be missing. eg, swimlane. 
Bridge support:
- Multiple checklist (adds task metadata into kanboard, even if not try checklist)
- Archived task (card), column (list)

Basic features:
- Checklist-bridge complete
- Bridge, linked task
- Add, remove, update items (project, task, subtask, comment)
- Cached data
- Archive-unarchive
- Amolded theme
- Attachments if simple
- Pin task to homescreen (android only?)
- Search: task, subtask & comments (local cache info or rely on `kanboard`?)
- Test if only sqlite or other `kanboard` DBs work (JSON type issues?)
- Replace newline for markdown with double newline
- Due date, task and subtask
- Date note added, all activity list (separate dialog/screen?)
- A common state listener for changes from different routes/screens, decide if task change matters to Board/Column screen etc, trigger rebuild, maybe mention scope of change

TODO:
- Link tasks
- (re-order) Drag & drop, header/checklist & items between checklists (`flutter_sticky_header`, `SliverReorderableList`)
- Test w/ and w/o bridge features/metadata
- Queue write tasks (offline support), bg service
- Load all projects, pull down refresh to force update, bg service
- Use multi-paragraph markdown: `flutter_markdown_selectionarea`
- Move/copy task
- Task bg or color
- Due date
- Task activity
- Attachments
- Favorite/starred tasks
- Optimize!
- Store updated accurate position info when deleting middle position items
- Show metadata of task (num comments, num of subtasks)
- Show progress of subtasks

Limitations:
These features are unlikely to be worked on either due to complexity, or due to limited understanding of its expected workflow.

- Swimlane support
- Multi user support / user show
- Subtask ordering will be different (uses metadata info to organize & decide position). If re-ordered in kanboard after in-app use, it will not be reflected.

Bugs:
- Archive/unarchive task, does not refresh the main screen (fix after cache)
- Views reload (while adding task, etc); optimization
- Default columns in new project
- Archive/unarchive incorrect reloading, better `key` usage 
- Close task would complete incomplete subtasks (use metadata for archive instead)
- perf: Re-use same pages/screens; search -> col -> search, etc

Test:
- Archive, unarchive cols, tasks

Possible Kanboard bugs:
- Inaccurate position info when deleting middle position items
- `removeColumn` not working