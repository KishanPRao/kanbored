import 'package:drift/drift.dart';

class ApiStorageModel extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get apiId => integer()();

  TextColumn get apiName => text()();

  // TODO: not API type, `scope` instead
  IntColumn get apiType => integer()();

  // TODO: Directly store json instead of unnecessary encode, decode
  TextColumn get webApiParams => text()();

  IntColumn get updateId => integer()();

  IntColumn get timestamp => integer()();
}
