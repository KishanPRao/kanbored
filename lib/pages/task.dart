import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:kanbored/api/api.dart';
import 'package:kanbored/models/subtask_model.dart';
import 'package:kanbored/models/task_model.dart';
import 'package:kanbored/ui/app_theme.dart';

class Task extends StatefulWidget {
  const Task({super.key});

  @override
  State<StatefulWidget> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  late TaskModel taskModel;

  List<SubtaskModel> subtasks = [];

  @override
  void didChangeDependencies() {
    taskModel = ModalRoute.of(context)?.settings.arguments as TaskModel;
    init();
    super.didChangeDependencies();
  }

  void init() async {
    var subtasks = await Api.getAllSubtasks(taskModel.id);
    setState(() {
      this.subtasks = subtasks;
    });
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
            child: Markdown(data: taskModel.description)
            // TextField(
            //     controller: TextEditingController()
            //       ..text = taskModel.description,
            //     maxLines: null,
            //     keyboardType: TextInputType.multiline,
            //     decoration: const InputDecoration(hintText: "Description"),
            //     enabled: false)
            ,
            //     children: taskModel.sub
            //         .map((Task) => Expanded(child: Column(
            //               children: [
            //                 Expanded(
            //                     child: ListView(
            //                       shrinkWrap: true,
            //                         scrollDirection: Axis.horizontal,
            //                         children: task
            //                             .map((column) => SizedBox(
            //                                 width: Utils.getWidth(context) * 0.7,
            //                                 child: buildSubtask(column, context)))
            //                             .toList()))
            //               ],
            //             )))
            //         .toList()),
          )
        ]));
  }
}
