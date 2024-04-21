import 'package:kanbored/db/database.dart';

extension AppDatabaseQuery on AppDatabase {
  Stream<List<ProjectModelData>> projects() => select(projectModel).watch();

  Stream<TaskMetadataModelData> taskMetadata(int? taskId) {
    if (taskId == null) {
      return const Stream.empty();
    }
    final query = select(taskMetadataModel)
      ..where((tbl) => tbl.taskId.equals(taskId));
    return query.watchSingle();
  }

  Stream<List<ColumnModelData>> columnsInProject(int? projectId) {
    if (projectId == null) {
      return const Stream.empty();
    }
    final query = select(columnModel)
      ..where((tbl) => tbl.projectId.equals(projectId));
    return query.watch();
  }

  Stream<List<TaskModelData>> tasksInProject(int? projectId) {
    if (projectId == null) {
      return const Stream.empty();
    }
    final query = select(taskModel)
      ..where((tbl) => tbl.projectId.equals(projectId));
    return query.watch();
  }
}
