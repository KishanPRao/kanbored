import 'dart:developer';

import 'package:drift/drift.dart' show DataClass;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/api/api.dart';
import 'package:kanbored/db/database.dart';
import 'package:kanbored/ui/ui_builder.dart';
import 'package:kanbored/utils/strings.dart';
import 'package:kanbored/ui/sizes.dart';
import 'package:kanbored/ui/ui_state.dart';
import 'package:kanbored/utils/utils.dart';

class Search extends ConsumerStatefulWidget {
  const Search({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => SearchState();
}

/// Search can be local (inside project), or global (outside);
/// search only specific project or everything
/// Search project, column, task, subtask, comment, checklist
class SearchState extends ConsumerState<Search> {
  bool isLoaded = false;

  // late ProjectModel projectModel;
  // late List<BoardModel> boards;
  Iterable<dynamic> filtered = [];
  String query = "";
  var controller = TextEditingController();

  @override
  void didChangeDependencies() {
    if (!isLoaded) {
      // var args = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
      // projectModel = args[0] as ProjectModel;
      // boards = args[1] as List<BoardModel>;
      isLoaded = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var scrollController = ScrollController();
    return PopScope(
        onPopInvoked: (didPop) =>
            ref.read(UiState.boardEditing.notifier).state = false,
        child: Scaffold(
            backgroundColor: "pageBg".themed(context),
            appBar: AppBar(
                backgroundColor: "primary".themed(context),
                // The search area here
                title: Container(
                  width: double.infinity,
                  height: Sizes.kSearchBarHeight,
                  decoration: BoxDecoration(
                      color: "searchBar".themed(context),
                      borderRadius: BorderRadius.circular(5)),
                  child: Center(
                    child: TextField(
                      autofocus: true,
                      controller: controller,
                      onChanged: (query) async {
                        // var filter = boards.expand((b) => b.filter(query));
                        // log("on text: $query; $filter");
                        // setState(() {
                        //   filtered = filter;
                        // });
                        List<dynamic> filtered = [];
                        if (query.isNotEmpty) {
                          var projs = await ref
                              .read(AppDatabase.provider)
                              .searchDao
                              .getProjects(query);
                          var cols = await ref
                              .read(AppDatabase.provider)
                              .searchDao
                              .getColumns(query);
                          var tasks = await ref
                              .read(AppDatabase.provider)
                              .searchDao
                              .getTasks(query);;
                          var subtasks = await ref
                              .read(AppDatabase.provider)
                              .searchDao
                              .getSubtasks(query);
                          var comments = await ref
                              .read(AppDatabase.provider)
                              .searchDao
                              .getComments(query);
                          var listTaskMetadata = await ref
                              .read(AppDatabase.provider)
                              .searchDao
                              .getChecklists(query);
                          filtered.addAll(projs);
                          filtered.addAll(cols);
                          filtered.addAll(tasks);
                          filtered.addAll(subtasks);
                          filtered.addAll(comments);
                          filtered.addAll(listTaskMetadata);
                        }
                        // for (var task in tasks) {
                        //   log("matched task: ${task.title}, with desc: ${task.description}");
                        // }
                        setState(() {
                          this.filtered = filtered;
                          this.query = query;
                        });
                      },
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () => controller.text = "",
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 10.0),
                          hintText: "search_bar_text".resc(),
                          hintStyle: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.italic),
                          border: InputBorder.none),
                    ),
                  ),
                )),
            body: Column(children: [
              Expanded(
                  child: ListView(
                // TODO: perf: better approach; everything causes refresh
                shrinkWrap: true,
                controller: scrollController,
                scrollDirection: Axis.vertical,
                children: filtered.map((model) {
                  if (model is ProjectModelData) {
                    return buildGenericModel(model.id, model.name, () {
                      // open project
                    },);
                  } else if (model is ColumnModelData) {
                    return buildGenericModel(model.id, model.title, () {
                      // open project with column in focus
                    },);
                  } else if (model is TaskModelData) {
                    return buildTask(model);
                  } else if (model is SubtaskModelData) {
                    return buildGenericModel(model.id, model.title, () {
                      // open task, with subtask in focus
                    },);
                  } else if (model is TaskMetadataModelData) {
                      for (var checklist in model.metadata.checklists) {
                        if (checklist.title.contains(query)) {
                          // TODO: checklist has ids inconsistent with kanboard
                          return buildGenericModel(checklist.id, checklist.title, () {
                            // open task with checklist in focus
                          },);
                        }
                      }
                  } else if (model is CommentModelData) {
                    return buildGenericModel(model.id, model.comment, () {
                      // open task, with comment in focus
                    },);
                  }
                  return Utils.emptyUi();
                }).toList(),
              ))
            ])));
  }

  Widget buildTask(TaskModelData task) {
    return UiBuilder.buildBoardTask(ref, task, context);
  }

  Widget buildGenericModel(int id, String text, Function() onTap) {
    return Card(
        key: ObjectKey(id),
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
        clipBehavior: Clip.hardEdge,
        color: "taskBg".themed(context),
        child: InkWell(
            splashColor: "cardHighlight".themed(context),
            highlightColor: "cardHighlight".themed(context),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                  height: Sizes.kTaskHeight,
                  child: Center(
                      child: Text(
                        text,
                        textAlign: TextAlign.center, // horizontal
                      ))),
            )));;
  }
}
