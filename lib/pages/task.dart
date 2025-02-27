import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/api/api.dart';
import 'package:kanbored/api/state.dart';
import 'package:kanbored/api/web_api.dart';
import 'package:kanbored/db/converters.dart';
import 'package:kanbored/db/dao/comment_dao.dart';
import 'package:kanbored/db/dao/subtask_dao.dart';
import 'package:kanbored/db/dao/task_metadata_dao.dart';
import 'package:kanbored/db/database.dart';
import 'package:kanbored/models/comment_model.dart';
import 'package:kanbored/models/subtask_model.dart';
import 'package:kanbored/models/task_metadata_model.dart';
import 'package:kanbored/models/task_model.dart';
import 'package:kanbored/ui/board_add_comment.dart';
import 'package:kanbored/ui/board_comments.dart';
import 'package:kanbored/ui/board_subtasks.dart';
import 'package:kanbored/ui/sizes.dart';
import 'package:kanbored/ui/ui_state.dart';
import 'package:kanbored/utils/strings.dart';
import 'package:kanbored/ui/abstract_app_bar.dart';
import 'package:kanbored/ui/add_comment.dart';
import 'package:kanbored/ui/app_theme.dart';
import 'package:kanbored/ui/build_subtasks.dart';
import 'package:kanbored/ui/editing_state.dart';
import 'package:kanbored/ui/markdown.dart';
import 'package:kanbored/ui/app_bar_action_listener.dart';
import 'package:kanbored/ui/task_app_bar.dart';
import 'package:kanbored/utils/utils.dart';

class Task extends ConsumerStatefulWidget {
  const Task({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TaskState();
}

class _TaskState extends ConsumerState<Task> {
  // late int taskId;
  // late int projectId;
  // late TaskModelData taskModel;
  // List<SubtaskModel> subtasks = [];
  // TaskMetadataModel taskMetadata = TaskMetadataModel(checklists: []);
  // List<CommentModel> comments = [];

  // GlobalKey<TaskAppBarActionsState> keyTaskAppBarActionsState = GlobalKey();
  // List<GlobalKey<EditableState>> keysEditableText = [];
  // var activeEditIndex = 0;
  // var activeEditText = "";
  // var isLoaded = false;
  // static const kDescriptionCount = 1;
  // static const kAddCommentCount = 1;
  List<Timer?> timers = [];
  late SubtaskDao subtaskDao;
  late CommentDao commentDao;
  late TaskMetadataDao taskMetadataDao;
  late double columnWidth;
  ScrollController scrollController = ScrollController();
  late GlobalKey<EditableState> keyDescription;
  late GlobalKey<EditableState> keyAddComment;

  Future<List<Timer?>?> updateData({bool recurring = false}) async {
    var taskModel = ref.read(activeTask)!;
    // taskId = taskModel.id;
    // TODO: if task is closed and re-opened, data isn't updated in db after being loaded
    return [
      Api.instance.updateSubtasks(ref, taskModel.id, recurring: recurring),
      Api.instance.updateComments(ref, taskModel.id, recurring: recurring),
      Api.instance
          .retrieveTaskMetadata(ref, taskModel.id, recurring: recurring),
    ];
  }

  @override
  void initState() {
    super.initState();
    // TODO: best approach? If retrieve server data at same time of edit? Or keep larger timeout for timer
    // Or pause timer when in edit mode
    updateData(recurring: true).then((timers) {
      if (timers != null) {
        this.timers = timers;
      }
    });
    // TODO: stop timer on dispose.
    // Api.updateColumns(ref, projectModel.id, recurring: true);
    // Api.updateTasks(ref, projectModel.id, recurring: true);
    subtaskDao = ref.read(AppDatabase.provider).subtaskDao;
    commentDao = ref.read(AppDatabase.provider).commentDao;
    taskMetadataDao = ref.read(AppDatabase.provider).taskMetadataDao;
    keyAddComment = EditableState.createKey();
    keyDescription = EditableState.createKey();
    // columns = ref.watch(columnsInProject);
    // columnsStream = buildColumns(context, projectModel.id);
    // final showArchived = ref.watch(UiState.boardShowArchived.notifier).stream.distinct();
    // showArchivedStream = ref.read(UiState.boardShowArchived.notifier).stream;
    Utils.runOnDraw((_) {
      columnWidth = Utils.getWidth(context) * Sizes.kTaskWidthPercentage; //TODO
    });
  }

  @override
  void dispose() {
    log("task dispose");
    for (var timer in timers) {
      timer?.cancel();
    }
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // if (!isLoaded) { // TODO
    //   var args = ModalRoute.of(context)?.settings.arguments;
    // if (args is TaskModel) {
    //   taskModel = args;
    //   taskId = taskModel.id;
    //   projectId = taskModel.projectId;
    // } else if (args is List<int>) {
    //   taskId = args[0];
    //   projectId = args[1];
    // }
    // init();
    // }
    super.didChangeDependencies();
  }

  void init() async {
    log("[task] init");
    // taskModel = await WebApi.getTask(taskId, projectId); // update task info
    // comments = [];
    // subtasks = [];
    // taskMetadata = TaskMetadataModel(checklists: []);
    // keysEditableText = [];
    // keysEditableText.add(GlobalKey()); // description
    // keysEditableText.add(GlobalKey()); // add-comment
    // var loadedSubtasks = <SubtaskModel>[];
    // var loadedComments = <CommentModel>[];
    // TaskMetadataModel loadedTaskMetadata =
    //     await WebApi.getTaskMetadata(taskModel.id);
    // // minimum 1, if no subtasks, show add new subtask
    // if (taskModel.nbSubtasks > 0) {
    //   loadedSubtasks = await WebApi.getAllSubtasks(taskModel.id);
    //   loadedSubtasks.sort((a, b) {
    //     // ascending
    //     if (a.position > b.position) {
    //       return 1;
    //     }
    //     return -1;
    //   });
    //   // add a `new subtask` for each checklist
    //   if (loadedTaskMetadata.checklists.isEmpty) {
    //     var items = <CheckListItemMetadata>[];
    //     for (var subtask in loadedSubtasks) {
    //       items.add(CheckListItemMetadata(id: subtask.id));
    //     }
    //     var checklist =
    //         CheckListMetadata(name: "Checklist", position: 1, items: items);
    //     loadedTaskMetadata.checklists.add(checklist);
    //     WebApi.saveTaskMetadata(taskModel.id, loadedTaskMetadata).then((value) {
    //       if (!value) {
    //         Utils.showErrorSnackbar(context, "Could not save task metadata");
    //       } else {
    //         log("stored task metadata: $loadedTaskMetadata");
    //       }
    //     }).catchError((e) => Utils.showErrorSnackbar(context, e));
    //   }
    // }
    // log("Loaded task metadata: $loadedTaskMetadata");
    // var checklistSubtaskCount =
    //     (loadedTaskMetadata.checklists.length * 2) + loadedSubtasks.length;
    // log("[init] Checklist + subtask count: $checklistSubtaskCount");
    // for (var i = 0; i < checklistSubtaskCount; i++) {
    //   keysEditableText.add(GlobalKey());
    // }
    // if (taskModel.nbComments > 0) {
    //   loadedComments = await WebApi.getAllComments(taskModel.id);
    //   loadedComments.sort((a, b) {
    //     if (a.dateCreation > b.dateCreation) {
    //       return -1;
    //     } else {
    //       return 1;
    //     }
    //   });
    //   for (var i = 0; i < loadedComments.length; i++) {
    //     keysEditableText.add(GlobalKey());
    //   }
    // }
    // log("loadedSubtasks: $loadedSubtasks");
    // setState(() {
    //   subtasks = loadedSubtasks;
    //   taskMetadata = loadedTaskMetadata;
    //   comments = loadedComments;
    //   isLoaded = true;
    // });
  }

  void onChange(text) {
    // activeEditText = text;
    // // keyTaskAppBarActionsState.currentState?.updateText(text);
  }

  void onEditStart(int index, List<int> actions) {
    log("onEditStart: $index");
    // activeEditIndex = index;
    // keyTaskAppBarActionsState.currentState?.currentActions = actions;
    // keyTaskAppBarActionsState.currentState?.startEdit();
  }

  // TODO: needed?
  bool onEditEnd(bool saveChanges) {
    // if (saveChanges && activeEditIndex != 0 && activeEditText.isEmpty) {
    //   return false;
    // }
    // log("onEditEnd: $activeEditIndex, $saveChanges");
    // keysEditableText[activeEditIndex].currentState?.endEdit(saveChanges);
    // keyTaskAppBarActionsState.currentState?.endEdit(saveChanges);
    // // setState(() {});
    return true;
  }

  void onDelete() {
    // log("onDelete");
    // keysEditableText[activeEditIndex].currentState?.delete();
  }

  void onCreateChecklist() {
    // var checklist = CheckListMetadata(
    //     name: "Checklist",
    //     position: taskMetadata.checklists.length + 1,
    //     items: []);
    // taskMetadata.checklists.add(checklist);
    // WebApi.saveTaskMetadata(taskModel.id, taskMetadata).then((value) {
    //   if (!value) {
    //     Utils.showErrorSnackbar(context, "Could not save task metadata");
    //   } else {
    //     log("stored new task metadata: $taskMetadata");
    //     refreshUi();
    //   }
    // }).catchError((e) => Utils.showErrorSnackbar(context, e));
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
    final task = ref.watch(activeTask);
    if (task == null) return Utils.emptyUi();
    // Reset task metadata
    // taskMetadataDao.updateTaskMetadata(task.id, {
    //   "metadata": {"checklists": []}
    // });
    // Do not load until some data is retrieved
    // if (!isLoaded) {
    //   return Utils.emptyUi();
    // }
    return Scaffold(
      backgroundColor: "pageBg".themed(context),
      appBar: AppBar(
          title: Text(task.title),
          backgroundColor: "primary".themed(context),
          leading: IconButton(
            onPressed: () {
              ref.read(UiState.boardEditing.notifier).state = false;
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          actions: [
            TaskAppBarActions(
                // key: keyTaskAppBarActionsState,
                // taskModel: taskModel,
                // abActionListener: AppBarActionListener(
                //   onChange: onChange,
                //   onEditStart: (_, __) => onEditStart(0, []),
                //   onEditEnd: onEditEnd,
                //   onDelete: onDelete,
                //   onMainAction: onCreateChecklist,
                //   refreshUi: refreshUi,
                // ),
                )
          ]),
      body: Column(children: [
        task.isActive == 1
            ? Utils.emptyUi()
            : Card(
                clipBehavior: Clip.hardEdge,
                color: "archivedBg".themed(context),
                child: SizedBox(
                  child: Center(child: Text("archived".resc())),
                )),
        Expanded(
            // TODO: use ListView.builder, fix complex multi-checklist logic
            child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                controller: scrollController,
                children: <Widget>[
              Markdown(
                key: keyDescription,
                content: task.description,
                onSaveCb: (text) {
                  log("[task] update desc");
                  Api.instance.updateTask(
                    ref,
                    task.copyWith(description: text),
                  );
                },
                // key: keysEditableText[0],
                // model: taskModel,
                // abActionListener: AppBarActionListener(
                //   onChange: onChange,
                //   onEditStart: (_, __) => onEditStart(
                //       0, [AppBarAction.kDiscard, AppBarAction.kDone]),
                //   onEditEnd: (saveChanges) {
                //     // TODO: allow empty desc, default hint text
                //     // updateDescription()
                //     return onEditEnd(saveChanges);
                //   },
                //   onDelete: onDelete,
                //   refreshUi: refreshUi,
                // )
              ),
              BoardSubtasks(task: task),

              // TODO: new key creation causes kb to keep closing on open
              // BoardAddComment(key: EditableState.createKey(), task: task),
              BoardAddComment(key: keyAddComment, task: task),
              BoardComments(task: task)
            ]
                // [buildSubtasksStream(taskModel.id)]
                // [Column(crossAxisAlignment: CrossAxisAlignment.start, children: [BoardSubtasks(task: task)])]
                // buildSubtasks(
                //     context,
                //     taskModel,
                //     subtasks,
                //     taskMetadata,
                //     keysEditableText,
                //     AppBarActionListener(
                //       onChange: onChange,
                //       onEditStart: (index, actions) =>
                //           onEditStart(index!, actions),
                //       onEditEnd: onEditEnd,
                //       onDelete: onDelete,
                //       refreshUi: refreshUi,
                //     ),
                //     toggleStatus) +
                // [
                //   AddComment(
                //       key: keysEditableText[
                //           checklistSubtaskCount + kDescriptionCount],
                //       task: taskModel,
                //       abActionListener: AppBarActionListener(
                //         onChange: onChange,
                //         onEditStart: (_, actions) => onEditStart(
                //             checklistSubtaskCount + kDescriptionCount,
                //             actions),
                //         onEditEnd: onEditEnd,
                //         onDelete: onDelete,
                //         refreshUi: refreshUi,
                //       ))
                // ] +
                // comments.mapIndexed((entry) {
                //   // TODO: Move into Comment & Description ui class, wrap Markdown
                //   int idx = entry.key;
                //   CommentModel comment = entry.value;
                //   return Markdown(
                //       key: keysEditableText[idx +
                //           checklistSubtaskCount +
                //           kDescriptionCount +
                //           kAddCommentCount],
                //       model: comment,
                //       abActionListener: AppBarActionListener(
                //         onChange: onChange,
                //         onEditStart: (_, __) => onEditStart(
                //             idx +
                //                 checklistSubtaskCount +
                //                 kDescriptionCount +
                //                 kAddCommentCount,
                //             [
                //               AppBarAction.kDelete,
                //               AppBarAction.kDiscard,
                //               AppBarAction.kDone
                //             ]),
                //         onEditEnd: (saveChanges) {
                //           // updateComment()
                //           return onEditEnd(saveChanges);
                //         },
                //         onDelete: onDelete,
                //         refreshUi: refreshUi,
                //       ));
                // }).toList()
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

  StreamBuilder<List<SubtaskModelData>> buildSubtasksStream(int taskId) {
    return StreamBuilder(
      // TODO: distinct matters?
      stream: subtaskDao.watchSubtasksInTask(taskId).distinct(),
      builder: (context, AsyncSnapshot<List<SubtaskModelData>> snapshot) {
        return StreamBuilder(
            stream: taskMetadataDao.watchTaskMetadataForTask(taskId),
            builder: (context, snapshot1) {
              // TODO: scenarios! Create new metadata etc
              var taskMetadata = snapshot1.data ??
                  TaskMetadataModelData(
                      taskId: taskId, metadata: TaskMetadata([]));
              var subtasks = snapshot.data ?? [];
              subtasks = subtasks + subtasks + subtasks + subtasks;
              log("new subtasks: ${subtasks.length}");
              var checklistSubtaskCount =
                  (taskMetadata.metadata.checklists.length * 2) +
                      subtasks.length;
              log("Checklist + subtask count: $checklistSubtaskCount");
              log("Checklist len: ${taskMetadata.metadata.checklists.length} subtask len: ${subtasks.length}");
              return Column(
                children: [
                  // TODO
                ],
              );
              // Expanded(child:
              //     ListView.builder(
              //   shrinkWrap: true,
              //   scrollDirection: Axis.vertical,
              //   controller: scrollController,
              //   itemCount: subtasks.length,
              //   itemBuilder: (_, index) {
              //     final subtask = subtasks[index];
              //     log("subtask: ${subtask.title}, ${subtask.id}");
              //     return SizedBox(height: 300, child: Text(subtask.title));
              //     // return SizedBox(
              //     //     key: ObjectKey(subtask.id),
              //     //     width: columnWidth,
              //     //     child: Text(subtask.title),
              //     //     // child: BoardColumn(
              //     //     //   // key: ObjectKey(subtask),
              //     //     //   column: subtask,
              //     //     // )
              //     // );
              //   },
              //   // )
              // );
            });
      },
    );
  }
}
