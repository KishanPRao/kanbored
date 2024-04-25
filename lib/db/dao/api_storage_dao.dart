import 'dart:developer';

import 'package:drift/drift.dart';
import 'package:kanbored/db/api_storage_model.dart';
import 'package:kanbored/db/database.dart';
import 'package:kanbored/utils.dart';

part 'api_storage_dao.g.dart';

@DriftAccessor(tables: [ApiStorageModel])
class ApiStorageDao extends DatabaseAccessor<AppDatabase>
    with _$ApiStorageDaoMixin {
  ApiStorageDao(super.db);

  void addApiTask(int apiId, String apiName, String apiBody) async {
    final timestamp = Utils.currentTimestampInMsec();
    // log("add api task: $timestamp");
    var data = ApiStorageModelCompanion(
      apiId: Value(apiId),
      apiName: Value(apiName),
      apiBody: Value(apiBody),
      timestamp: Value(timestamp),
    );
    await into(apiStorageModel).insert(data);
  }

  void removeApiTask(int id) async {
    (delete(apiStorageModel)..where((tbl) => tbl.id.equals(id))).go();
  }

  Stream<ApiStorageModelData?> watchApiLatest() {
    final query = select(apiStorageModel)
      ..orderBy([
        (t) => OrderingTerm(expression: t.timestamp, mode: OrderingMode.asc)
      ])
      ..limit(1);
    return query.watchSingleOrNull();
  }

  Stream<List<ApiStorageModelData>> watchApiTasks() {
    return select(apiStorageModel).watch();
  }
}
