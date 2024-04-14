class TaskActionListener {
  final Function(String) onChange;
  final Function(int?) onEditStart; // include array of valid actions
  final bool Function(bool) onEditEnd;
  final Function() onDelete;
  final Function()? onCreateChecklist;
  final Function() refreshUi;

  TaskActionListener({
    required this.onChange,
    required this.onEditStart,
    required this.onEditEnd,
    required this.onDelete,
    this.onCreateChecklist,
    required this.refreshUi,
  });
}
