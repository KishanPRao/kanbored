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

Limitations:
- User info not properly retained / shown
- Subtask ordering will be different (uses metadata info to organize & decide position). If re-ordered in kanboard after in-app use, it will not be reflected.

Basic features:
- Checklist-bridge complete
- Bridge, linked task
- Multi-line subtasks
- Add, remove, update items (project, task, subtask, comment)
- Archive-unarchive
- Amolded theme
- Attachments if simple
- Pin task to homescreen (android only?)
- Search: task, subtask & comments (local cache info or rely on `kanboard`?)
- Test if only sqlite or other `kanboard` DBs work (JSON type issues?)

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

Unlikely:
- Swimlane support