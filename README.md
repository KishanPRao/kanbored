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
- Multiple checklist
- Archived task (card), column (list)

Limitations:
- User info not properly retained / shown

TODO:
- Test w/ and w/o bridge features/metadata
- Optimize!