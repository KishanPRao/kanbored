import 'dart:convert';
import 'dart:developer';

import 'package:drift/drift.dart';
import 'package:kanbored/db/api_storage_model.dart';
import 'package:kanbored/db/database.dart';
import 'package:kanbored/db/web_api_model.dart';
import 'package:kanbored/utils/utils.dart';

part 'api_storage_dao.g.dart';

@DriftAccessor(tables: [ApiStorageModel])
class ApiStorageDao extends DatabaseAccessor<AppDatabase>
    with _$ApiStorageDaoMixin {
  ApiStorageDao(super.db);

  void addApiTask(WebApiModel webApiModel, Map<String, dynamic> apiParams,
      int updateId) async {
    final timestamp = Utils.currentTimestampInMsec();
    log("add api task: $timestamp");
    var data = ApiStorageModelCompanion(
      apiId: Value(webApiModel.apiId),
      apiType: Value(webApiModel.apiType),
      apiName: Value(webApiModel.apiName),
      webApiParams: Value(json.encode(apiParams)),
      updateId: Value(updateId),
      timestamp: Value(timestamp),
    );
    await into(apiStorageModel).insert(data);
  }

  void updateApiTask(int oldId, int newId, int apiType) async {
    // (delete(apiStorageModel)..where((tbl) => tbl.id.equals(oldId))).go();
    log("updateApiTask: $oldId => $newId; $apiType");
    // final apiTasks = await (select(apiStorageModel)
    //       ..where((tbl) => tbl.updateId.equals(oldId))
    //       ..where((tbl) => tbl.apiType.equals(apiType)))
    //     .get();
    // for (var apiTask in apiTasks) {
    //   var updatedApiTask = apiTask.copyWith(
    //       webApiParams: apiTask.webApiParams
    //           .replaceAll("\"$apiUpdateId\"", newId.toString()));
    //   (update(apiStorageModel)..where((tbl) => tbl.id.equals(apiTask.id)))
    //       .write(updatedApiTask);
    // }
    (update(apiStorageModel)
          ..where((tbl) => tbl.updateId.equals(oldId))
          ..where((tbl) => tbl.apiType.equals(apiType)))
        .write(ApiStorageModelCompanion(updateId: Value(newId)));
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
