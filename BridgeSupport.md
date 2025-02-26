## Checklist

Each subtask belongs to a checklist.
TrelloJson2KB creates checklists, while kanboard doesn't support it.
If Desktop KB creates subtask, first open of task, create default checklist, assign all subtasks to it.
Offline, should be straightforward.

TaskMetadata = [ ChecklistMetadata ]; Task metadata could contain other info later.
ChecklistMetadata = [ name, position wrt checklist, [ CheckListItemMetadata ] ]
CheckListItemMetadata = subtask id; this could contain more info later.