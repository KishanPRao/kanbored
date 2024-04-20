import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:kanbored/strings.dart';
import 'package:kanbored/ui/app_bar_action_listener.dart';
import 'package:kanbored/utils.dart';
import 'editing_state.dart';

class AppBarAction {
  static const kDelete = 0;
  static const kDiscard = 1;
  static const kDone = 2;
  static const kMain = 3;
  static const kPopup = 4;
}

abstract class AppBarActions extends StatefulWidget {
  final AppBarActionListener abActionListener;

  const AppBarActions({super.key, required this.abActionListener});
}

abstract class AppBarActionsState<T extends AppBarActions>
    extends EditableState<T> {
  late AppBarActionListener abActionListener;
  bool _editing = false;
  var defaultActions = [
    AppBarAction.kMain,
    AppBarAction.kPopup,
  ];
  var currentActions = [];

  @override
  void initState() {
    super.initState();
    abActionListener = widget.abActionListener;
  }

  @override
  void startEdit() {
    setState(() {
      _editing = true;
    });
  }

  @override
  void endEdit(bool saveChanges) {
    if (_editing) {
      setState(() {
        _editing = false;
      });
    }
  }

  void stopEdit(bool saveChanges) {
    if (abActionListener.onEditEnd(saveChanges)) {
      endEdit(saveChanges);
    }
  }

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
          onPressed: () => stopEdit(false),
          // color: showActive ? Colors.grey : Colors.red, //TODO
          icon: const Icon(Icons.undo),
          tooltip: "tt_discard".resc(),
        );
      case AppBarAction.kDone:
        return IconButton(
          onPressed: () => stopEdit(true),
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

  @override
  Widget build(BuildContext context) {
    return Row(
        children: (_editing ? currentActions : defaultActions)
            .map((e) => getButton(e))
            .toList());
  }
}
