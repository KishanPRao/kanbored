import 'dart:convert';
import 'dart:developer';

import 'package:drift/drift.dart';
import 'package:kanbored/db/api_storage_model.dart';
import 'package:kanbored/db/converters.dart';
import 'package:kanbored/db/database.dart';
import 'package:kanbored/utils/utils.dart';

part 'api_storage_dao.g.dart';

@DriftAccessor(tables: [ApiStorageModel])
class ApiStorageDao extends DatabaseAccessor<AppDatabase>
    with _$ApiStorageDaoMixin {
  ApiStorageDao(super.db);

  void addApiTask(WebApiModel webApiModel, Map<String, dynamic> apiBody,
      int updateId) async {
    final timestamp = Utils.currentTimestampInMsec();
    log("add api task: $timestamp");
    var data = ApiStorageModelCompanion(
      webApiInfo: Value(webApiModel),
      webApiBody: Value(json.encode(apiBody)),
      updateId: Value(updateId),
      timestamp: Value(timestamp),
    );
    await into(apiStorageModel).insert(data);
  }

  void removeApiTask(int id) async {
    (delete(apiStorageModel)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<ApiStorageModelData?> getApiLatest() {
    final query = select(apiStorageModel)
      ..orderBy([
        (t) => OrderingTerm(expression: t.timestamp, mode: OrderingMode.asc)
      ])
      ..limit(1);
    return query.getSingleOrNull();
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
