import 'package:drift/drift.dart';

class ApiStorageModel extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get apiId => integer()();

  TextColumn get apiName => text()();

  TextColumn get apiBody => text()();

  IntColumn get timestamp => integer()();
}
