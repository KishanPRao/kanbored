import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kanbored/strings.dart';

import 'editing_state.dart';

class TaskAppBarActions extends StatefulWidget {
  final Function(bool) onEditEnd;

  const TaskAppBarActions({super.key, required this.onEditEnd});

  @override
  State<StatefulWidget> createState() => TaskAppBarActionsState();
}

class TaskAppBarActionsState extends EditableState<TaskAppBarActions> {
  bool _editing = false;
  String _text = "";
  late Function(bool) onEditEnd;

  @override
  void initState() {
    super.initState();
    onEditEnd = widget.onEditEnd;
  }

  void startEdit() => setState(() {
        _editing = true;
      });

  @override
  void endEdit() => setState(() {
        _editing = false;
      });

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
                  onPressed: () {
                    onEditEnd(false);
                    setState(() {
                      _editing = false;
                    });
                  },
                  // color: showActive ? Colors.grey : Colors.red, //TODO
                  icon: const Icon(Icons.undo),
                  tooltip: "tt_discard".resc(),
                ),
                IconButton(
                  onPressed: () {
                    onEditEnd(true);
                    setState(() {
                      _editing = false;
                    });
                  },
                  // color: showActive ? Colors.grey : Colors.red, //TODO
                  icon: const Icon(Icons.done),
                  tooltip: "tt_save".resc(),
                )
              ]
            : [
                PopupMenuButton<String>(
                  onSelected: handleClick,
                  itemBuilder: (BuildContext context) {
                    return {"archive".resc(), "delete".resc()}
                        .map((String choice) {
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
