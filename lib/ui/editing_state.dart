import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/ui/abstract_app_bar.dart';
import 'package:kanbored/ui/ui_state.dart';

abstract class EditableState<T extends ConsumerStatefulWidget>
    extends ConsumerState<T> {
  static final defaultActions = [
    AppBarAction.kMain,
    AppBarAction.kPopup,
  ];
  late final List<int> editActions;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: "");
  }

  void startEdit() {
    ref.read(UiState.boardActiveState.notifier).state =
        widget.key as GlobalKey<EditableState>;
    ref.read(UiState.boardActiveText.notifier).state = controller.text;
    ref.read(UiState.boardActions.notifier).state = editActions;
    ref.read(UiState.boardEditing.notifier).state = true;
  }

  Future<bool> endEdit(bool saveChanges) async {
    final activeText = ref.read(UiState.boardActiveText);
    if (saveChanges && activeText.isEmpty) {
      return false;
    }
    ref.read(UiState.boardEditing.notifier).state = false;
    ref.read(UiState.boardActions.notifier).state = defaultActions;
    return true;
  }

  void delete() {}

  void archive() {}

  void unarchive() {}

  static GlobalKey<EditableState> createKey() => GlobalKey<EditableState>();
}
