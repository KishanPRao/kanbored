import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/db/database.dart';
import 'package:kanbored/db/database_query.dart';

final activeProject = StateProvider<ProjectModelData?>((ref) => null);
// final productsProvider = StateNotifierProvider<ProductsNotifier, List<Product>>((ref) => ProductsNotifier());
final columnsInProject = StreamProvider((ref) {
  final database = ref.watch(AppDatabase.provider);
  final current = ref.watch(activeProject)?.id;
  return database.columnsInProject(current);
});
final currentProjects = StreamProvider((ref) {
  final database = ref.watch(AppDatabase.provider);
  return database.currentProjects();
});
