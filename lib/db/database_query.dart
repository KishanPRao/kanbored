import 'package:kanbored/db/database.dart';

extension AppDatabaseQuery on AppDatabase {

  Stream<List<ProjectModelData>> currentProjects() => select(projectModel).watch();

  Stream<List<ColumnModelData>> columnsInProject(int? projectId) {
    if (projectId == null) {
      return const Stream.empty();
    }
    final query = select(columnModel)..where((tbl) => tbl.projectId.equals(projectId));

    return query.watch();
  }
}