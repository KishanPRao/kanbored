import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/strings.dart';
import 'package:kanbored/ui/ui_state.dart';
import 'package:kanbored/utils.dart';

import 'editing_state.dart';

class AppBarAction {
  static const kDelete = 0;
  static const kDiscard = 1;
  static const kDone = 2;
  static const kMain = 3;
  static const kPopup = 4;
}

abstract class AppBarActions extends ConsumerStatefulWidget {
  const AppBarActions({super.key});
}

abstract class AppBarActionsState<T extends AppBarActions>
    extends EditableState<T> {
  static final defaultActions = [
    AppBarAction.kMain,
    AppBarAction.kPopup,
  ];
  var currentActions = [];
  StreamBuilder<bool>? editingStream;
  // StreamBuilder<Iterable<int>>? actionsStream;

  @override
  void startEdit() {
    log("app bar start edit");
    // setState(() {
    //   _editing = true;
    // });
  }

  @override
  void endEdit(bool saveChanges) {
    log("app bar end edit: $saveChanges");
    final activeText = ref.read(UiState.boardActiveText);
    if (saveChanges && activeText.isEmpty) {
      return;
    }
    ref.read(UiState.boardEditing.notifier).state = false;
    ref.read(UiState.boardActions.notifier).state = defaultActions;
    ref.read(UiState.boardActiveState.notifier).state?.currentState?.endEdit(saveChanges);
    // if (_editing) {
    //   setState(() {
    //     _editing = false;
    //   });
    // }
  }

  void mainAction();

  // void stopEdit(bool saveChanges) {
  //   // if (abActionListener.onEditEnd(saveChanges)) {
  //   //   endEdit(saveChanges);
  //   // }
  // }

  Iterable<String> getPopupNames();

  // TODO: find out why re-build invoked
  Future<void> handlePopupAction(String action);

  Widget getButton(int action) {
    // log("getButton: $action");
    switch (action) {
      case AppBarAction.kDelete:
        return IconButton(
          onPressed: () => delete(),
          // color: showActive ? Colors.grey : Colors.red, //TODO
          icon: const Icon(Icons.delete),
          tooltip: "delete".resc(),
        );
      case AppBarAction.kDiscard:
        return IconButton(
          onPressed: () => endEdit(false),
          // color: showActive ? Colors.grey : Colors.red, //TODO
          icon: const Icon(Icons.undo),
          tooltip: "tt_discard".resc(),
        );
      case AppBarAction.kDone:
        return IconButton(
          onPressed: () => endEdit(true),
          // color: showActive ? Colors.grey : Colors.red, //TODO
          icon: const Icon(Icons.done),
          tooltip: "tt_done".resc(),
        );
      case AppBarAction.kPopup:
        return PopupMenuButton<String>(
          onSelected: handlePopupAction,
          itemBuilder: (BuildContext context) {
            return getPopupNames().map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        );
      default:
        log("Could not find matching app bar action buttons!");
        return Utils.emptyUi();
    }
  }

  void buildEditingStream() {}

  @override
  Widget build(BuildContext context) {
    editingStream ??= StreamBuilder(
      // TODO: editing state required?
      stream: ref.watch(UiState.boardEditing.notifier).stream.distinct(),
      builder: (context, snapshot) {
        final editing = snapshot.data ?? false;
        log("edit stream");
        return Row(
            children:
                (editing ? ref.read(UiState.boardActions) : defaultActions)
                    .map((e) => getButton(e))
                    .toList());
      },
    );
    // actionsStream ??= StreamBuilder(
    //   // TODO: editing state required?
    //   stream: ref.watch(UiState.boardActions.notifier).stream.distinct(),
    //   builder: (context, snapshot) {
    //     final actions = snapshot.data ?? [];
    //     log("edit stream");
    //     return Row(children: actions.map((e) => getButton(e)).toList());
    //   },
    // );
    // return actionsStream!;
    return editingStream!;
  }
}
