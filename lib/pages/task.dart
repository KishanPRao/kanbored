import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:kanbored/api/api.dart';
import 'package:kanbored/models/comment_model.dart';
import 'package:kanbored/models/subtask_model.dart';
import 'package:kanbored/models/task_metadata_model.dart';
import 'package:kanbored/models/task_model.dart';
import 'package:kanbored/ui/app_theme.dart';
import 'package:kanbored/ui/multi_list_subtasks.dart';
import 'package:kanbored/ui/single_list_subtasks.dart';

class Task extends StatefulWidget {
  const Task({super.key});

  @override
  State<StatefulWidget> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  late TaskModel taskModel;
  List<SubtaskModel> subtasks = [];
  TaskMetadataModel? taskMetadata;
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
      var taskMetadata = await Api.getTaskMetadata(taskModel.id);
      setState(() {
        this.subtasks = subtasks;
        this.taskMetadata = taskMetadata;
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
    toggleStatus(subtask, value) {
      setState(() {
        subtask.status =
            value ? SubtaskModel.kStatusFinished : SubtaskModel.kStatusTodo;
      });
    }

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
            child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: <Widget>[
                      Markdown(data: taskModel.description, shrinkWrap: true)
                    ] +
                    buildSubtasks(
                        context, subtasks, taskMetadata, toggleStatus) +
                    comments
                        .map(
                            (comment) => SizedBox(child: Text(comment.comment)))
                        .toList())),
      ]),
    );
  }
}
