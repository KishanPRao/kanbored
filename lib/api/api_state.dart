import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/models/column_model.dart';
import 'package:kanbored/models/comment_model.dart';
import 'package:kanbored/models/project_metadata_model.dart';
import 'package:kanbored/models/project_model.dart';
import 'package:kanbored/models/subtask_model.dart';
import 'package:kanbored/models/task_metadata_model.dart';
import 'package:kanbored/models/task_model.dart';

// TODO: default offline or online?
class ApiState {
  static final onlineStatus = StateProvider<bool?>((ref) => null);
  static final allProjects = StateProvider<List<ProjectModel>>((ref) => []);
  static final columnsInActiveProject = StateProvider<List<ColumnModel>>((ref) => []);
  static final tasksInActiveProject = StateProvider<List<TaskModel>>((ref) => []);
  static final subtasksInActiveTask = StateProvider<List<SubtaskModel>>((ref) => []);
  static final commentsInActiveTask = StateProvider<List<CommentModel>>((ref) => []);
  // static final activeBoards = StateProvider<List<BoardModel>>((ref) => []);

  static final activeProject = StateProvider<ProjectModel?>((ref) => null);
  // static final activeProjectMetadata =
  //     StateProvider<ProjectMetadataModel?>((ref) => null);
  // static final activeColumn = StateProvider<ColumnModel?>((ref) => null);
  static final activeTask = StateProvider<TaskModel?>((ref) => null);
  static final activeTaskMetadata =
      StateProvider<TaskMetadataModel?>((ref) => null);
}
