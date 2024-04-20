import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kanbored/api/api.dart';
import 'package:kanbored/models/board_model.dart';
import 'package:kanbored/models/column_model.dart';
import 'package:kanbored/models/model.dart';
import 'package:kanbored/models/project_model.dart';
import 'package:kanbored/models/task_model.dart';
import 'package:kanbored/strings.dart';
import 'package:kanbored/ui/build_subtasks.dart';
import 'package:kanbored/ui/sizes.dart';
import 'package:kanbored/utils.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<StatefulWidget> createState() => SearchState();
}

class SearchState extends State<Search> {
  bool isLoaded = false;
  late ProjectModel projectModel;
  late List<BoardModel> boards;
  Iterable<Model> filtered = [];
  var controller = TextEditingController();

  @override
  void didChangeDependencies() {
    if (!isLoaded) {
      var args = ModalRoute.of(context)?.settings.arguments as List<dynamic>;
      projectModel = args[0] as ProjectModel;
      boards = args[1] as List<BoardModel>;
      isLoaded = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var scrollController = ScrollController();
    return Scaffold(
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
                  onChanged: (query) {
                    var filter = boards.expand((b) => b.filter(query));
                    log("on text: $query; $filter");
                    setState(() {
                      filtered = filter;
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
              if (model is TaskModel) {
                return buildBoardTask(model, context);
              } else if (model is ColumnModel) {
                return buildBoardColumn(model, context, () {
                  Navigator.pop(context, model);
                });
              }
              return Utils.emptyUi();
            }).toList(),
          ))
        ]));
  }
}
