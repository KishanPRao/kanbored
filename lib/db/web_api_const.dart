import 'package:kanbored/db/converters.dart';

class WebApiConst {
  static const createProject = WebApiModel(1797076613, typeProject);
  static const addColumn = WebApiModel(638544704, typeColumn);
  static const createTask = WebApiModel(1176509098, typeTask);
  static const createSubtask = WebApiModel(2041554661, typeSubtask);
  static const createComment = WebApiModel(1580417921, typeComment);
  static const saveProjectMetadata =
      WebApiModel(1797076613, typeProjectMetadata);
  static const saveTaskMetadata = WebApiModel(133280317, typeTaskMetadata);

  static const updateProject = WebApiModel(1853996288, typeProject);
  static const updateColumn = WebApiModel(480740641, typeColumn);
  static const updateTask = WebApiModel(1406803059, typeTask);
  static const updateComment = WebApiModel(496470023, typeComment);
  static const updateSubtask = WebApiModel(191749979, typeSubtask);
  static const enableProject = WebApiModel(1775494839, typeProject);
  static const disableProject = WebApiModel(1734202312, typeProject);
  static const openTask = WebApiModel(1888531925, typeTask);
  static const closeTask = WebApiModel(1654396960, typeTask);

  static const removeProject = WebApiModel(46285125, typeProject);
  static const removeColumn = WebApiModel(1433237746, typeColumn);
  static const removeTask = WebApiModel(1423501287, typeTask);
  static const removeComment = WebApiModel(328836871, typeComment);
  static const removeSubtask = WebApiModel(1382487306, typeSubtask);

  static const getAllProjects = WebApiModel(2134420212, typeProject);
  static const getBoard = WebApiModel(827046470, typeBoard);
  static const getColumns = WebApiModel(887036325, typeColumn);
  static const getAllTasks = WebApiModel(133280317, typeTask);
  static const getAllSubtasks = WebApiModel(2087700490, typeSubtask);
  static const getAllComments = WebApiModel(148484683, typeComment);
  static const searchTasks = WebApiModel(1468511716, typeTask);
  static const getTask = WebApiModel(700738119, typeTask);
  static const getTaskMetadata = WebApiModel(133280317, typeTaskMetadata);
  static const getProjectMetadata =
      WebApiModel(1797076613, typeProjectMetadata);

  static const typeProject = 0;
  static const typeBoard = 1;
  static const typeColumn = 2;
  static const typeTask = 3;
  static const typeSubtask = 4;
  static const typeComment = 5;
  static const typeProjectMetadata = 6;
  static const typeTaskMetadata = 7;
}
