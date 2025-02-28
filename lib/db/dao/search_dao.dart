import 'dart:developer';

import 'package:drift/drift.dart';
import 'package:kanbored/db/column_model.dart';
import 'package:kanbored/db/comment_model.dart';
import 'package:kanbored/db/database.dart';
import 'package:kanbored/db/subtask_model.dart';
import 'package:kanbored/db/task_model.dart';
import 'package:kanbored/db/project_model.dart';

part 'search_dao.g.dart';

@DriftAccessor(tables: [ProjectModel, ColumnModel, TaskModel, SubtaskModel, CommentModel, TaskMetadataModel])
class SearchDao extends DatabaseAccessor<AppDatabase> with _$SearchDaoMixin {
  SearchDao(super.db);

  /// With title or desc
  Future<List<TaskModelData>> getTasks(String text) async {
    final query = select(taskModel)
      ..where((tbl) {
        return tbl.title.like('%$text%') | tbl.description.like('%$text%');
      })
      ..orderBy([(t) => OrderingTerm(expression: t.position)]);
    return await query.get();
  }

  // TODO: column has description!?
  Future<List<ColumnModelData>> getColumns(String text) async {
    final query = select(columnModel)
      ..where((tbl) {
        return tbl.title.like('%$text%');
      })
      ..orderBy([(t) => OrderingTerm(expression: t.position)]);
    return await query.get();
  }

  // TODO: project has description!?
  Future<List<ProjectModelData>> getProjects(String text) async {
    final query = select(projectModel)
      ..where((tbl) {
        return tbl.name.like('%$text%');
      })
      ..orderBy([(t) => OrderingTerm(expression: t.name)]);
    return await query.get();
  }

  Future<List<SubtaskModelData>> getSubtasks(String text) async {
    final query = select(subtaskModel)
      ..where((tbl) {
        return tbl.title.like('%$text%');
      })
      ..orderBy([(t) => OrderingTerm(expression: t.status)]);
    return await query.get();
  }

  Future<List<CommentModelData>> getComments(String text) async {
    final query = select(commentModel)
      ..where((tbl) {
        return tbl.comment.like('%$text%');
      })
      // TODO: nullable date creation! locally generated
      ..orderBy([(t) => OrderingTerm(expression: t.dateCreation)]);
    return await query.get();
  }

  Future<List<TaskMetadataModelData>> getChecklists(String text) async {
    final query = select(taskMetadataModel)
      ..where((tbl) {
        return tbl.metadata.like("\"title\":%\"$text\"%");
      });
    return await query.get();
  }
}
