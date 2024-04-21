import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/db/database.dart';
import 'package:kanbored/db/database_query.dart';

final activeProject = StateProvider<ProjectModelData?>((ref) => null);
final columnsInProject = StreamProvider((ref) {
  final database = ref.watch(AppDatabase.provider);
  final current = ref.watch(activeProject)?.id;
  return database.columnsInProject(current);
});
final currentProjects = StreamProvider((ref) {
  final database = ref.watch(AppDatabase.provider);
  return database.projects();
});

// final isLoadingProvider = StateProvider((ref) => false);