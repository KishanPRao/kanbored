import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kanbored/strings.dart';

import 'editing_state.dart';

class TaskAppBarActions extends StatefulWidget {
  final bool Function(bool) onEditEnd;

  const TaskAppBarActions({super.key, required this.onEditEnd});

  @override
  State<StatefulWidget> createState() => TaskAppBarActionsState();
}

class TaskAppBarActionsState extends EditableState<TaskAppBarActions> {
  bool _editing = false;
  String _text = "";
  late bool Function(bool) onEditEnd;

  @override
  void initState() {
    super.initState();
    onEditEnd = widget.onEditEnd;
  }

  void startEdit() {
    if (!_editing) {
      setState(() {
        _editing = true;
      });
    }
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
    if (onEditEnd(saveChanges)) {
      endEdit(saveChanges);
    }
  }

  void updateText(String value) => _text = value;

  void handleClick(String value) {
    log("opt: $value");
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        children: _editing
            ? [
                IconButton(
                  onPressed: () => stopEdit(false),
                  // color: showActive ? Colors.grey : Colors.red, //TODO
                  icon: const Icon(Icons.undo),
                  tooltip: "tt_discard".resc(),
                ),
                IconButton(
                  onPressed: () => stopEdit(true),
                  // color: showActive ? Colors.grey : Colors.red, //TODO
                  icon: const Icon(Icons.done),
                  tooltip: "tt_save".resc(),
                )
              ]
            : [
                PopupMenuButton<String>(
                  onSelected: handleClick,
                  itemBuilder: (BuildContext context) {
                    return {
                      "add_checklist".resc(),
                      "archive".resc(),
                      "delete".resc(),
                    }.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                )
              ]);
  }
}
