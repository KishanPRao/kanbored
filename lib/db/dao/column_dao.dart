
import 'dart:developer';

import 'package:drift/drift.dart';
import 'package:kanbored/db/database.dart';
import 'package:kanbored/db/column_model.dart';

part 'column_dao.g.dart';

@DriftAccessor(tables: [ColumnModel])
class ColumnDao extends DatabaseAccessor<AppDatabase> with _$ColumnDaoMixin {
  ColumnDao(super.db);

  Stream<List<ColumnModelData>> watchColumnsInProject(int projectId) {
    final query = select(columnModel)
      ..where((tbl) {
        return tbl.projectId.equals(projectId);
      })
      ..orderBy([(t) => OrderingTerm(expression: t.position)]);
    return query.watch();
  }

  void updateColumns(List<dynamic> items) {
    db.transaction(() async {
      // log("# projects ${projects.length}");
      for (var item in items) {
        // log("project: $project");
        var data = ColumnModelData.fromJson(item);
        // log("project data: ${data.name}");
        await into(columnModel).insertOnConflictUpdate(data);
      }
    });
  }

  void updateColumn(ColumnModelData data) async {
    await into(columnModel).insertOnConflictUpdate(data);
  }
}