import 'package:drift/drift.dart';
import 'package:kanbored/db/project_model.dart';

class ColumnModel extends Table {
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
  IntColumn get projectId => integer().references(ProjectModel, #id)();
}
