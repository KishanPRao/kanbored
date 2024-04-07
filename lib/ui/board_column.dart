import 'package:flutter/material.dart';
import 'package:kanbored/constants.dart';
import 'package:kanbored/models/column_model.dart';
import 'package:kanbored/models/subtask_model.dart';
import 'package:kanbored/models/task_model.dart';
import 'package:kanbored/strings.dart';
import 'package:kanbored/ui/add_task.dart';
import 'package:kanbored/ui/sizes.dart';

class BoardColumn extends StatefulWidget {
  final bool showActive;
  final ColumnModel column;
  final Function(String) createTaskCb;

  const BoardColumn(
      {required this.column,
      required this.showActive,
      required this.createTaskCb,
      super.key});

  @override
  State<StatefulWidget> createState() => BoardColumnState();
}

class BoardColumnState extends State<BoardColumn> {
  late List<TaskModel> _tasks;
  late int _tasksLength;
  late bool _showActive;
  late ColumnModel _column;
  late Function(String) _createTaskCb;

  @override
  void initState() {
    super.initState();
    _createTaskCb = widget.createTaskCb;
    _column = widget.column;
    _showActive = widget.showActive;
    _tasks = (_showActive ? _column.activeTasks : _column.tasks);
    _tasksLength = (_showActive ? _tasks.length + 1 : _tasks.length);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        color: "columnBg".themed(context),
        margin: const EdgeInsets.all(10),
        clipBehavior: Clip.hardEdge,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(_column.title) as Widget,
              Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: _tasksLength,
                      itemBuilder: (context, index) {
                        if (_showActive && index == _tasks.length) {
                          return SizedBox(
                              child: buildBoardAddTaskAction(
                                  context, _createTaskCb));
                        }
                        return SizedBox(
                            child: buildBoardTask(
                                _tasks.elementAt(index), context));
                      }))
            ])));
  }
}

Widget buildBoardAddTaskAction(
    BuildContext context, Function(String) createTaskCb) {
  return AddTask(createTaskCb: createTaskCb);
}

Widget buildBoardTask(TaskModel task, BuildContext context) {
  return Card(
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
      clipBehavior: Clip.hardEdge,
      color: "taskBg".themed(context),
      child: InkWell(
          splashColor: "primary".themed(context).withAlpha(30),
          onTap: () {
            Navigator.pushNamed(context, routeTask, arguments: task);
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
                height: Sizes.kTaskHeight,
                child: Center(
                    child: Text(
                  task.title,
                  textAlign: TextAlign.center, // horizontal
                ))),
          )));
}

Widget buildSubtask(SubtaskModel subtask, BuildContext context) {
  bool isChecked = false;
  return Row(children: [
    Checkbox(
      value: isChecked,
      onChanged: (value) {
        isChecked = value!;
      },
    ),
    Text(subtask.title)
  ]);
}
