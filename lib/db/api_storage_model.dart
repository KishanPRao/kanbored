import 'package:drift/drift.dart';
import 'package:kanbored/db/converters.dart';

class ApiStorageModel extends Table {
  IntColumn get id => integer().autoIncrement()();

  // IntColumn get apiId => integer()();
  //
  // TextColumn get apiName => text()();
  // TextColumn get webApiInfo => text()();
  TextColumn get webApiInfo => text().map(const WebApiModelConverter())();

  TextColumn get webApiBody => text()();

  IntColumn get updateId => integer()();

  // IntColumn get updateType => integer()();

  IntColumn get timestamp => integer()();
}
