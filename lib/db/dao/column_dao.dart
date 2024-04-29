import 'dart:developer';

import 'package:drift/drift.dart';
import 'package:kanbored/db/column_model.dart';
import 'package:kanbored/db/database.dart';

part 'column_dao.g.dart';

@DriftAccessor(tables: [ColumnModel])
class ColumnDao extends DatabaseAccessor<AppDatabase> with _$ColumnDaoMixin {
  ColumnDao(super.db);

  Future<int> addColumn(int localId, String title, int projectId) async {
    return transaction(() async {
      // var lowestIdItem = await (select(columnModel)
      //       ..orderBy(
      //           [(t) => OrderingTerm(expression: t.id, mode: OrderingMode.asc)])
      //       ..limit(1))
      //     .getSingleOrNull();
      var highestPositionItem = await (select(columnModel)
            ..orderBy([
              (t) =>
                  OrderingTerm(expression: t.position, mode: OrderingMode.desc)
            ])
            ..limit(1))
          .getSingleOrNull();
      // log("lowestIdItem: ${lowestIdItem?.id}, ${lowestIdItem?.title}");
      // final lowestId = lowestIdItem?.id ?? 0;
      final highestPosition = highestPositionItem?.position ?? 0;
      var data = ColumnModelCompanionExt.create(
          localId, title, projectId, highestPosition);
      log("dao, addColumn");
      return await into(columnModel).insertOnConflictUpdate(data);
    });
  }

  void updateColumn(ColumnModelData data) async {
    await into(columnModel).insertOnConflictUpdate(data);
  }

  void updateId(int oldId, int newId) async {
    (update(columnModel)..where((tbl) => tbl.id.equals(oldId)))
        .write(ColumnModelCompanion(id: Value(newId)));
  }

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
}
