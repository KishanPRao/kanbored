import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/api/state.dart';
import 'package:kanbored/db/database.dart';
import 'package:kanbored/ui/sizes.dart';
import 'package:kanbored/utils/constants.dart';
import 'package:kanbored/utils/strings.dart';

class UiBuilder {
  static Widget buildBoardTask(
      WidgetRef ref, TaskModelData task, BuildContext context) {
    // log("Board task: ${task.title} at ${task.position}");
    return Card(
        key: ObjectKey(task.id),
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
        clipBehavior: Clip.hardEdge,
        color: "taskBg".themed(context),
        child: InkWell(
            splashColor: "cardHighlight".themed(context),
            highlightColor: "cardHighlight".themed(context),
            onTap: () {
              ref.read(activeTask.notifier).state = task;
              Navigator.pushNamed(context, routeTask);
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
}
