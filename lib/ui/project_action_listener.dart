import 'package:kanbored/ui/app_bar_action_listener.dart';

class ProjectActionListener extends AppBarActionListener {
  final Function(bool) onArchived;

  ProjectActionListener(
      {required this.onArchived,
      required super.onChange,
      required super.onEditStart,
      required super.onEditEnd,
      required super.onDelete,
      required super.onMainAction,
      required super.refreshUi});
}
