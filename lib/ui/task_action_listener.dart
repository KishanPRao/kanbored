import 'package:kanbored/ui/task_app_bar.dart';

class TaskActionListener {
  final Function(String) onChange;
  final Function(int?, List<TaskAppBarAction>) onEditStart; // include array of valid actions
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
