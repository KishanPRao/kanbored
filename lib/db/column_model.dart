import 'package:drift/drift.dart';
import 'package:kanbored/db/database.dart';

class ColumnModel extends Table {
  @override
  Set<Column> get primaryKey => {id, projectId};

  IntColumn get id => integer()();

  TextColumn get title => text()();

  IntColumn get position => integer()();

  @JsonKey('task_limit')
  IntColumn get taskLimit => integer()();

  TextColumn get description => text()();

  // TODO: use instead of isActive
  @JsonKey('hide_in_dashboard')
  IntColumn get hideInDashboard => integer()();

  @JsonKey('project_id')
  IntColumn get projectId => integer().references(ColumnModel, #id)();
}

extension ColumnModelCompanionExt on ColumnModelCompanion {
  static ColumnModelCompanion create(
      int id, String title, int projectId, int position,
      {String description = "", int hideInDashboard = 0, int taskLimit = 0}) {
    return ColumnModelCompanion(
        id: Value(id),
        title: Value(title),
        projectId: Value(projectId),
        description: Value(description),
        hideInDashboard: Value(hideInDashboard),
        position: Value(position),
        taskLimit: Value(taskLimit));
  }
}
