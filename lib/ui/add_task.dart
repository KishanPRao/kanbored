import 'package:flutter/material.dart';
import 'package:kanbored/strings.dart';
import 'package:kanbored/ui/sizes.dart';

class AddTask extends StatefulWidget {
  final Function(String) createTaskCb;

  const AddTask({required this.createTaskCb, super.key});

  @override
  State<StatefulWidget> createState() => AddTaskState();
}

class AddTaskState extends State<AddTask> {
  var editing = false;
  var taskName = "";
  var validText = false;
  var focusNode = FocusNode();
  late Function(String) createTaskCb;

  @override
  void initState() {
    super.initState();
    createTaskCb = widget.createTaskCb;
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
      color: Colors.transparent,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
          // splashColor: "primary".themed(context).withAlpha(30),
          onTap: () {
            setState(() {
              focusNode.requestFocus();
            });
          },
          child: SizedBox(
            height: Sizes.kAddTaskHeight,
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(children: [
                  Expanded(
                      child: TextField(
                    onChanged: (value) {
                      setState(() {
                        validText = value.isNotEmpty;
                        taskName = value;
                      });
                    },
                    onEditingComplete: () {
                      if (validText) {
                        createTaskCb(taskName);
                      }
                    },
                    focusNode: focusNode,
                    decoration: InputDecoration(hintText: "add_task".resc()),
                  )),
                  IconButton(
                      onPressed:
                          validText ? () => createTaskCb(taskName) : null,
                      icon: const Icon(Icons.check))
                ])),
          )),
    );
  }
}
