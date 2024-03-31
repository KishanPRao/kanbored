import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:kanbored/api/api.dart';
import 'package:kanbored/models/comment_model.dart';
import 'package:kanbored/models/subtask_model.dart';
import 'package:kanbored/models/task_model.dart';
import 'package:kanbored/ui/app_theme.dart';
import 'package:kanbored/ui/board_column.dart';

class Task extends StatefulWidget {
  const Task({super.key});

  @override
  State<StatefulWidget> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  late TaskModel taskModel;
  List<SubtaskModel> subtasks = [];
  List<CommentModel> comments = [];

  @override
  void didChangeDependencies() {
    taskModel = ModalRoute.of(context)?.settings.arguments as TaskModel;
    init();
    super.didChangeDependencies();
  }

  void init() async {
    if (taskModel.nbSubtasks > 0) {
      var subtasks = await Api.getAllSubtasks(taskModel.id);
      setState(() {
        this.subtasks = subtasks;
      });
    }
    if (taskModel.nbComments > 0) {
      var comments = await Api.getAllComments(taskModel.id);
      setState(() {
        this.comments = comments;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(taskModel.title),
          backgroundColor: context.theme.appColors.primary,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: Column(children: [
          Expanded(
            child: Column(children: [
              Markdown(data: taskModel.description, shrinkWrap: true),
              Expanded(
                  // Subtasks
                  flex: 0,
                  child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: subtasks
                          .map((subtask) => Row(children: [
                                Checkbox(
                                  checkColor:
                                      Colors.white, // TODO: themed color!
                                  fillColor: MaterialStateProperty.resolveWith(
                                      (states) {
                                    if (states
                                        .contains(MaterialState.selected)) {
                                      return context.theme.appColors.primary;
                                    }
                                    return Colors.transparent;
                                  }),
                                  value: subtask.status ==
                                      SubtaskModel.kStatusFinished,
                                  onChanged: (value) {
                                    setState(() {
                                      subtask.status = value!
                                          ? SubtaskModel.kStatusFinished
                                          : SubtaskModel.kStatusTodo;
                                    });
                                  },
                                ),
                                Expanded(child: Text(subtask.title))
                              ]))
                          .toList())),
              Expanded(
                  // Comments
                  // flex: 0,
                  child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: comments
                          .map((comment) =>
                              SizedBox(child: Text(comment.comment)))
                          .toList()))
            ]),
          )
        ]));
  }
}
