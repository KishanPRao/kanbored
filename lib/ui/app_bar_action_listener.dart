import 'package:kanbored/ui/abstract_app_bar.dart';
import 'package:kanbored/ui/task_app_bar.dart';

class AppBarActionListener {
  final Function(String) onChange;
  final Function(int?, List<int>) onEditStart; // include array of valid actions
  final bool Function(bool) onEditEnd;
  final Function() onDelete;
  final Function()? onMainAction;
  final Function() refreshUi;

  AppBarActionListener({
    required this.onChange,
    required this.onEditStart,
    required this.onEditEnd,
    required this.onDelete,
    this.onMainAction,
    required this.refreshUi,
  });
}
