import 'package:flutter/material.dart';

// import 'package:flutter_markdown_editor/editor_field.dart';
// import 'package:flutter_markdown_editor/flutter_markdown_editor.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';
// import 'package:markdown/markdown.dart' as md;
import 'package:kanbored/api/api.dart';
import 'package:kanbored/models/comment_model.dart';
import 'package:kanbored/models/subtask_model.dart';
import 'package:kanbored/models/task_metadata_model.dart';
import 'package:kanbored/models/task_model.dart';
import 'package:kanbored/strings.dart';
import 'package:kanbored/ui/build_subtasks.dart';
import 'package:kanbored/ui/markdown.dart';

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

    ScrollController scrollController = ScrollController();
    var textController = TextEditingController();
    textController.text = taskModel.description;
    // final MarkDownEditor markDownEditor = MarkDownEditor(controller: textController);
    // var field = markDownEditor.field as MrkdownEditingField;
    // field.controller.
    return Scaffold(
      appBar: AppBar(
        title: Text(taskModel.title),
        backgroundColor: "primary".themed(context),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                });
              },
              // color: showActive ? Colors.grey : Colors.red, //TODO
              icon: const Icon(Icons.done),
              tooltip: "TODO".resc(),
            )
          ]
      ),
      body: Column(children: [
        Expanded(
            // TODO: use ListView.builder, fix complex multi-checklist logic
            child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                controller: scrollController,
                children: <Widget>[
                      Markdown(text: taskModel.description, onChange: (String ) {

                      },)
                          // Scrollbar(
                          //   child: SingleChildScrollView(
                          //     child: Markdown(
                          //       controller: ScrollController(),
                          //       selectable: true,
                          //       onTapLink: (_, href, __) async {
                          //         // if (href == null || !await canLaunch(href)) {
                          //         //   Fluttertoast.showToast(
                          //         //     msg: "Couldn't open the URL",
                          //         //     toastLength: Toast.LENGTH_SHORT,
                          //         //     gravity: ToastGravity.CENTER,
                          //         //     timeInSecForIosWeb: 1,
                          //         //     backgroundColor: Colors.red,
                          //         //     textColor: Colors.white,
                          //         //     fontSize: 16.0,
                          //         //   );
                          //         // } else {
                          //         //   launch(href);
                          //         // }
                          //       },
                          //       data: taskModel.description,
                          //       shrinkWrap: true,
                          //       extensionSet: md.ExtensionSet(
                          //         md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                          //         [
                          //           md.EmojiSyntax(),
                          //           ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // )
                          // markDownEditor.vertical(),
                          // markDownEditor.inPlace(),
                          // MarkDownEditor(
                          //   controller: _textController,
                          // data: taskModel.description,
                          // controller: scrollController,
                          // shrinkWrap: true,
                          // // selectable: true, // TODO
                          // // onSelectionChanged: (text, selection, cause) {
                          // // },
                          // styleSheet: MarkdownStyleSheet(
                          //   p: const TextStyle(fontSize: 15),
                          // )
                          // ),

                    ] +
                    buildSubtasks(
                        context, subtasks, taskMetadata, toggleStatus) +
                    comments
                        .map((comment) => Text(comment.comment)
                            // markDownEditor.inPlace()
                            // Markdown(
                            //     data: comment.comment,
                            //     shrinkWrap: true,
                            //     controller: scrollController,
                            //     styleSheet: MarkdownStyleSheet(
                            //       p: const TextStyle(fontSize: 15),
                            //     ))
                            )
                        .toList())),
      ]),
    );
  }
}
