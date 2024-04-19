import 'package:kanbored/ui/app_bar_action_listener.dart';

class BoardActionListener extends AppBarActionListener {
  final Function() onArchive;
  final Function() onUnarchive;
  final Function() onArchived;

  BoardActionListener(
      {
        required this.onArchive,
        required this.onUnarchive,
        required this.onArchived,
      required super.onChange,
      required super.onEditStart,
      required super.onEditEnd,
      required super.onDelete,
      required super.onMainAction,
      required super.refreshUi});
}
