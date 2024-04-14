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
import 'package:kanbored/ui/task_action_listener.dart';
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
  TaskMetadataModel taskMetadata = TaskMetadataModel(checklists: []);
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
    log("init");
    taskModel = await Api.getTask(
        taskModel.id, taskModel.projectId); // update task info
    comments = [];
    subtasks = [];
    taskMetadata = TaskMetadataModel(checklists: []);
    keysEditableText = [];
    keysEditableText.add(GlobalKey()); // description
    var loadedSubtasks = <SubtaskModel>[];
    var loadedComments = <CommentModel>[];
    TaskMetadataModel loadedTaskMetadata;
    // minimum 1, if no subtasks, show add new subtask
    if (taskModel.nbSubtasks > 0) {
      loadedSubtasks = await Api.getAllSubtasks(taskModel.id);
      loadedTaskMetadata = await Api.getTaskMetadata(taskModel.id);
      // add a `new subtask` for each checklist
    } else {
      loadedTaskMetadata = TaskMetadataModel(checklists: []);
    }
    log("Loaded task metadata: $loadedTaskMetadata");
    if (loadedTaskMetadata.checklists.isEmpty) {
      var items = <CheckListItemMetadata>[];
      for (var subtask in loadedSubtasks) {
        items.add(CheckListItemMetadata(id: subtask.id));
      }
      var checklist =
          CheckListMetadata(name: "Checklist", position: 1, items: items);
      loadedTaskMetadata.checklists.add(checklist);
      Api.saveTaskMetadata(taskModel.id, loadedTaskMetadata).then((value) {
        if (!value) {
          Utils.showErrorSnackbar(context, "Could not save task metadata");
        } else {
          log("stored task metadata: $loadedTaskMetadata");
        }
      }).catchError((e) => Utils.showErrorSnackbar(context, e));
    }
    var checklistSubtaskCount =
        (loadedTaskMetadata.checklists.length * 2) + loadedSubtasks.length;
    log("[init] Checklist + subtask count: $checklistSubtaskCount");
    for (var i = 0; i < checklistSubtaskCount; i++) {
      keysEditableText.add(GlobalKey());
    }
    if (taskModel.nbComments > 0) {
      loadedComments = await Api.getAllComments(taskModel.id);
      for (var i = 0; i < loadedComments.length; i++) {
        keysEditableText.add(GlobalKey());
      }
    }
    log("loadedSubtasks: $loadedSubtasks");
    setState(() {
      subtasks = loadedSubtasks;
      taskMetadata = loadedTaskMetadata;
      comments = loadedComments;
    });
  }

  void onChange(text) {
    activeEditText = text;
    // keyTaskAppBarActionsState.currentState?.updateText(text);
  }

  void onEditStart(int index) {
    activeEditIndex = index;
    keyTaskAppBarActionsState.currentState?.startEdit();
  }

  // TODO: needed?
  bool onEditEnd(bool saveChanges) {
    if (saveChanges && activeEditText.isEmpty) return false;
    log("onEditEnd: $activeEditIndex, $saveChanges");
    keysEditableText[activeEditIndex].currentState?.endEdit(saveChanges);
    // setState(() {});
    return true;
  }

  void onDelete() {
    log("onDelete");
    keysEditableText[activeEditIndex].currentState?.delete();
  }

  void refreshUi() {
    log("Refresh UI!");
    // setState(() {});
    init();
  }

  void toggleStatus(subtask, value) {
    setState(() {
      subtask.status =
          value ? SubtaskModel.kStatusFinished : SubtaskModel.kStatusTodo;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Do not load until some data is retrieved
    if (taskMetadata.checklists.isEmpty) {
      return const SizedBox.shrink();
    }

    ScrollController scrollController = ScrollController();
    var checklistSubtaskCount =
        (taskMetadata.checklists.length * 2) + subtasks.length;
    log("Checklist + subtask count: $checklistSubtaskCount");
    log("Checklist len: ${taskMetadata.checklists.length} subtask len: ${subtasks.length}");
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
              taskActionListener: TaskActionListener(
                onChange: onChange,
                onEditStart: (_) => onEditStart(0),
                onEditEnd: onEditEnd,
                onDelete: onDelete,
                refreshUi: refreshUi,
              ),
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
                          model: taskModel,
                          taskActionListener: TaskActionListener(
                            onChange: onChange,
                            onEditStart: (_) => onEditStart(0),
                            onEditEnd: (saveChanges) {
                              // updateDescription()
                              return onEditEnd(saveChanges);
                            },
                            onDelete: onDelete,
                            refreshUi: refreshUi,
                          ))
                    ] +
                    buildSubtasks(
                        context,
                        taskModel,
                        subtasks,
                        taskMetadata,
                        keysEditableText,
                        TaskActionListener(
                          onChange: onChange,
                          onEditStart: (index) => onEditStart(index!),
                          onEditEnd: onEditEnd,
                          onDelete: onDelete,
                          refreshUi: refreshUi,
                        ),
                        toggleStatus) +
                    comments.mapIndexed((entry) {
                      int idx = entry.key;
                      CommentModel comment = entry.value;
                      return Markdown(
                          key:
                              keysEditableText[idx + checklistSubtaskCount + 1],
                          model: comment,
                          taskActionListener: TaskActionListener(
                            onChange: onChange,
                            onEditStart: (_) =>
                                onEditStart(idx + checklistSubtaskCount + 1),
                            onEditEnd: (saveChanges) {
                              // updateComment()
                              return onEditEnd(saveChanges);
                            },
                            onDelete: onDelete,
                            refreshUi: refreshUi,
                          ));
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
