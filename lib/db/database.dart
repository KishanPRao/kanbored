import 'dart:developer';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/db/dao/comment_dao.dart';
import 'package:kanbored/db/dao/search_dao.dart';
import 'package:kanbored/db/dao/subtask_dao.dart';
import 'package:kanbored/db/dao/task_metadata_dao.dart';
import 'package:kanbored/db/web_api_model.dart';
import 'package:kanbored/db/api_storage_model.dart';
import 'package:kanbored/db/column_model.dart';
import 'package:kanbored/db/comment_model.dart';
import 'package:kanbored/db/converters.dart';
import 'package:kanbored/db/dao/api_storage_dao.dart';
import 'package:kanbored/db/dao/column_dao.dart';
import 'package:kanbored/db/dao/project_dao.dart';
import 'package:kanbored/db/dao/task_dao.dart';
import 'package:kanbored/db/project_model.dart';
import 'package:kanbored/db/subtask_model.dart';
import 'package:kanbored/db/task_model.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

part 'database.g.dart';

@DriftDatabase(tables: [
  ColumnModel,
  CommentModel,
  ProjectModel,
  SubtaskModel,
  TaskModel,
  TaskMetadataModel,
  ApiStorageModel,
], daos: [
  ProjectDao,
  ColumnDao,
  TaskDao,
  SubtaskDao,
  CommentDao,
  TaskMetadataDao,
  ApiStorageDao,
  SearchDao,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static final StateProvider<AppDatabase> provider = StateProvider((ref) {
    final database = AppDatabase();
    ref.onDispose(database.close);
    return database;
  });
}

  LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    // if (kDebugMode) {
    //   log("deleting database file");
    //   if (await file.exists()) {
    //     await file.delete();
    //   }
    // }

    // Also work around limitations on old Android versions
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    // Make sqlite3 pick a more suitable location for temporary files - the
    // one from the system may be inaccessible due to sandboxing.
    final cachebase = (await getTemporaryDirectory()).path;
    // We can't access /tmp on Android, which sqlite3 would try by default.
    // Explicitly tell it about the correct temporary directory.
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
}


extension DataClassExtension on DataClass {
  dynamic toJsonWithKeys(List<String> keys) {
    dynamic jsonData = toJson();
    if (jsonData is Map<String, dynamic>) {
      jsonData.removeWhere((key, value) => !keys.contains(key));
      return jsonData;
    } else {
      log("Other");
    }
    return jsonData;
  }
}