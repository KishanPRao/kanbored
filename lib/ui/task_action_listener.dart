class TaskActionListener {
  final Function(String) onChange;
  final Function(int?) onEditStart;
  final bool Function(bool) onEditEnd;
  final Function() refreshUi;

  TaskActionListener({
    required this.onChange,
    required this.onEditStart,
    required this.onEditEnd,
    required this.refreshUi,
  });
}
