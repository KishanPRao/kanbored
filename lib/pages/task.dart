import 'dart:developer';

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
import 'package:kanbored/ui/editing_state.dart';
import 'package:kanbored/ui/markdown.dart';
import 'package:kanbored/ui/task_app_bar.dart';
import 'package:kanbored/utils.dart';

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
  GlobalKey<TaskAppBarActionsState> keyTaskAppBarActionsState = GlobalKey();
  List<GlobalKey<EditableState>> keysEditableText = [];
  var activeEditIndex = 0;
  var activeEditText = "";

  @override
  void didChangeDependencies() {
    taskModel = ModalRoute.of(context)?.settings.arguments as TaskModel;
    init();
    super.didChangeDependencies();
  }

  void init() async {
    comments = [];
    subtasks = [];
    taskMetadata = null;
    keysEditableText = [];
    keysEditableText.add(GlobalKey());
    var loadedSubtasks = <SubtaskModel>[];
    var loadedComments = <CommentModel>[];
    TaskMetadataModel? loadedTaskMetadata;
    if (taskModel.nbSubtasks > 0) {
      loadedSubtasks = await Api.getAllSubtasks(taskModel.id);
      loadedTaskMetadata = await Api.getTaskMetadata(taskModel.id);
      var checklistSubtaskCount = (loadedTaskMetadata.checklists.isNotEmpty
              ? loadedTaskMetadata.checklists.length * 2
              : 1) +
          loadedSubtasks.length; // add a new subtask for each checklist
      for (var i = 0; i < checklistSubtaskCount; i++) {
        keysEditableText.add(GlobalKey());
      }
    }
    if (taskModel.nbComments > 0) {
      loadedComments = await Api.getAllComments(taskModel.id);
      for (var i = 0; i < loadedComments.length; i++) {
        keysEditableText.add(GlobalKey());
      }
    }
    setState(() {
      subtasks = loadedSubtasks;
      taskMetadata = loadedTaskMetadata;
      comments = loadedComments;
    });
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
    onChange(text) {
      activeEditText = text;
      // log("onChange: $text");
      keyTaskAppBarActionsState.currentState?.updateText(text);
    }

    onEditStart(int index) {
      log("onEditStart: $index");
      activeEditIndex = index;
      keyTaskAppBarActionsState.currentState?.startEdit();
    }

    bool onEditEnd(bool saveChanges) {
      if (saveChanges && activeEditText.isEmpty) return false;
      log("onEditEnd: $activeEditIndex, $saveChanges");
      keysEditableText[activeEditIndex].currentState?.endEdit(saveChanges);
      return true;
    }

    var checklistSubtaskCount = 0;
    var taskMetadata = this.taskMetadata;
    if (taskMetadata != null) {
      if (taskMetadata.checklists.isNotEmpty) {
        checklistSubtaskCount += taskMetadata.checklists.length *
            2; // each checklist has a `add subtask`
      } else {
        checklistSubtaskCount += 1;
      }
    }
    checklistSubtaskCount += subtasks.length;
    // var checklistSubtaskCount =
    //     (taskMetadata?.checklists.length ?? 0) + subtasks.length;
    // var checklistSubtaskCount = (((taskMetadata?.checklists.isNotEmpty ? taskMetadata?.checklists.length * 2
    //     : 1)) ?? 0)
    //      +
    //     subtasks.length;
    log("Checklist subtask count: $checklistSubtaskCount");
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
            TaskAppBarActions(
              key: keyTaskAppBarActionsState,
              onEditEnd: onEditEnd,
            )
          ]),
      body: Column(children: [
        Expanded(
            // TODO: use ListView.builder, fix complex multi-checklist logic
            child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                controller: scrollController,
                children: <Widget>[
                      Markdown(
                          key: keysEditableText[0],
                          text: taskModel.description,
                          onChange: onChange,
                          onEditStart: () => onEditStart(0))
                    ] +
                    buildSubtasks(
                        context,
                        subtasks,
                        taskMetadata,
                        keysEditableText,
                        onChange,
                        onEditStart,
                        onEditEnd,
                        toggleStatus) +
                    comments.mapIndexed((entry) {
                      int idx = entry.key;
                      CommentModel comment = entry.value;
                      return Markdown(
                          key:
                              keysEditableText[idx + checklistSubtaskCount + 1],
                          text: comment.comment,
                          onChange: onChange,
                          onEditStart: () =>
                              onEditStart(idx + checklistSubtaskCount + 1));
                    }).toList()
                // markDownEditor.inPlace()
                // Markdown(
                //     data: comment.comment,
                //     shrinkWrap: true,
                //     controller: scrollController,
                //     styleSheet: MarkdownStyleSheet(
                //       p: const TextStyle(fontSize: 15),
                //     ))
                )),
      ]),
    );
  }
}
