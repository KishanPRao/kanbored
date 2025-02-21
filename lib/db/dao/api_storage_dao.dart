import 'dart:convert';
import 'dart:developer';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/api/state.dart';
import 'package:kanbored/db/api_storage_model.dart';
import 'package:kanbored/db/database.dart';
import 'package:kanbored/db/web_api_model.dart';
import 'package:kanbored/utils/utils.dart';

part 'api_storage_dao.g.dart';

@DriftAccessor(tables: [ApiStorageModel])
class ApiStorageDao extends DatabaseAccessor<AppDatabase>
    with _$ApiStorageDaoMixin {
  ApiStorageDao(super.db);

  void addApiTask(
      WebApiModel webApiModel, dynamic apiParams, int updateId) async {
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

  void updateApiTask(int oldId, int newId, ApiStorageModelData updateApi) async {
    // (delete(apiStorageModel)..where((tbl) => tbl.id.equals(oldId))).go();
    log("updateApiTask: $oldId => $newId; type=${updateApi.apiType}");
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
    // (update(apiStorageModel)
    //       ..where((tbl) => tbl.updateId.equals(oldId))
    //       ..where((tbl) => tbl.apiType.equals(apiType)))
    //     .write(ApiStorageModelCompanion(updateId: Value(newId)));
    // TODO: use directly `id`?
    // (update(apiStorageModel)
    //       ..where((tbl) => tbl.updateId.equals(oldId))
    //       // ..where((tbl) => tbl.apiType.equals(apiTask.apiType))
    // ).write(
    //   ApiStorageModelCompanion(
    //     webApiParams: Value(entity.webApiParams.replaceAll(
    //         "\"${Utils.generateUpdateIdString(oldId)}\"",
    //         "\"${Utils.generateUpdateIdString(newId)}\"")),
    //     updateId: Value(newId),
    //   ),
    // );
    // into(apiStorageModel).insert(
    //   ApiStorageModelCompanion.insert(
    //     apiName: apiTask.apiName,
    //     apiId: apiTask.apiId,
    //     apiType: apiTask.apiType,
    //     id: Value(apiTask.id),
    //     webApiParams: Value.absent(),
    //   ),
    //   onConflict: DoUpdate((old) =>
    //       ApiStorageModelCompanion.custom(webApiParams: old.webApiParams)),
    // );
    await transaction(() async {
      final apiTasks = await (select(apiStorageModel)).get();
      for (var apiTask in apiTasks) {
        if (apiTask.apiType <= updateApi.apiType) {
          log("updateApiTask, ignoring: prev type=${updateApi.apiType}, check type=${apiTask.apiType}");
          continue;
        }
        var updatedApiTask = apiTask.copyWith(
          webApiParams: apiTask.webApiParams.replaceAll(
              "\"${Utils.generateUpdateIdString(oldId)}\"",
              "$newId"
          ),
        );
        // log("update api: \"${Utils.generateUpdateIdString(oldId)}\" => \"${Utils.generateUpdateIdString(newId)}\"");
        log("update api: ${apiTask.webApiParams} => ${updatedApiTask.webApiParams}");
        // (update(apiStorageModel)..where((tbl) => tbl.id.equals(apiTask.id)))
        // (update(apiStorageModel))
        //     .write(updatedApiTask);
        await into(apiStorageModel).insertOnConflictUpdate(updatedApiTask);
        log("update db FIN: $oldId => $newId");
      }
    });
    final apiTasks = await (select(apiStorageModel)).get();
    for (var apiTask in apiTasks) {
      log("all tasks: ${apiTask.apiName}, ${apiTask.webApiParams}");
    }
    log("updateApiTask FIN: $oldId => $newId; ${updateApi.apiType}");
  }

  Future<List<ApiStorageModelData>> getTasks() async {
    final apiTasks = await (select(apiStorageModel)).get();
    for (var apiTask in apiTasks) {
      log("getTasks: ${apiTask.apiName}, ${apiTask.webApiParams}, ${apiTask.id}, ${apiTask.updateId}");
    }
    return apiTasks;
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

  // Get next lowest update id
  Future<int> nextId() async {
    var lowestIdItem = await (select(apiStorageModel)
          ..orderBy(
              [(t) => OrderingTerm(expression: t.updateId, mode: OrderingMode.asc)])
          ..limit(1))
        .getSingleOrNull();
    // TODO: directly use `id` instead?
    log("lowest id: ${lowestIdItem?.updateId}, ${lowestIdItem?.apiName}, ${lowestIdItem?.updateId}; new: ${(lowestIdItem?.updateId ?? 0) - 1}");
    getTasks();
    return (lowestIdItem?.updateId ?? 0) - 1;
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
