import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kanbored/strings.dart';
import 'package:kanbored/ui/task_action_listener.dart';

import 'editing_state.dart';

class TaskAppBarActions extends StatefulWidget {
  final TaskActionListener taskActionListener;

  const TaskAppBarActions({super.key, required this.taskActionListener});

  @override
  State<StatefulWidget> createState() => TaskAppBarActionsState();
}

class TaskAppBarActionsState extends EditableState<TaskAppBarActions> {
  bool _editing = false;
  // String _text = "";
  late TaskActionListener taskActionListener;

  @override
  void initState() {
    super.initState();
    taskActionListener = widget.taskActionListener;
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

  @override
  void delete() => taskActionListener.onDelete();

  void stopEdit(bool saveChanges) {
    if (taskActionListener.onEditEnd(saveChanges)) {
      endEdit(saveChanges);
    }
  }

  // void updateText(String value) => _text = value;

  void handleClick(String value) {
    log("opt: $value");
  }

  List<Widget> buildDefaultActions() {
    return [
      IconButton(
        onPressed: () {
          log("Add comment");
        },
        icon: const Icon(Icons.add_comment),
        tooltip: "add_comment".resc(),
      ),
      IconButton(
        onPressed: () {
          log("Add checklist");
        },
        icon: const Icon(Icons.format_list_bulleted_add),
        tooltip: "add_checklist".resc(),
      ),
      PopupMenuButton<String>(
        onSelected: handleClick,
        itemBuilder: (BuildContext context) {
          return {
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
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        children: _editing
            ? [
                IconButton(
                  onPressed: () => delete(),
                  // color: showActive ? Colors.grey : Colors.red, //TODO
                  icon: const Icon(Icons.delete),
                  tooltip: "delete".resc(),
                ),
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
            : buildDefaultActions());
  }
}
