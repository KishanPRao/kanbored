class WebApiModel {
  static const createProject =
      WebApiModel(1797076613, "createProject", typeProject);
  static const addColumn = WebApiModel(638544704, "addColumn", typeColumn);
  static const createTask = WebApiModel(1176509098, "createTask", typeTask);
  static const createSubtask =
      WebApiModel(2041554661, "createSubtask", typeSubtask);
  static const createComment =
      WebApiModel(1580417921, "createComment", typeComment);
  static const saveProjectMetadata =
      WebApiModel(1797076613, "saveProjectMetadata", typeProjectMetadata);
  static const saveTaskMetadata =
      WebApiModel(133280317, "saveTaskMetadata", typeTaskMetadata);
  static const updateProject =
      WebApiModel(1853996288, "updateProject", typeProject);
  static const updateColumn =
      WebApiModel(480740641, "updateColumn", typeColumn);
  static const updateTask = WebApiModel(1406803059, "updateTask", typeTask);
  static const updateComment =
      WebApiModel(496470023, "updateComment", typeComment);
  static const updateSubtask =
      WebApiModel(191749979, "updateSubtask", typeSubtask);
  static const enableProject =
      WebApiModel(1775494839, "enableProject", typeProject);
  static const disableProject =
      WebApiModel(1734202312, "disableProject", typeProject);
  static const openTask = WebApiModel(1888531925, "openTask", typeTask);
  static const closeTask = WebApiModel(1654396960, "closeTask", typeTask);
  static const removeProject =
      WebApiModel(46285125, "removeProject", typeProject);
  static const removeColumn =
      WebApiModel(1433237746, "removeColumn", typeColumn);
  static const removeTask = WebApiModel(1423501287, "removeTask", typeTask);
  static const removeComment =
      WebApiModel(328836871, "removeComment", typeComment);
  static const removeSubtask =
      WebApiModel(1382487306, "removeSubtask", typeSubtask);
  static const getAllProjects =
      WebApiModel(2134420212, "getAllProjects", typeProject);
  static const getBoard = WebApiModel(827046470, "getBoard", typeBoard);
  static const getColumns = WebApiModel(887036325, "getColumns", typeColumn);
  static const getAllTasks = WebApiModel(133280317, "getAllTasks", typeTask);
  static const getAllSubtasks =
      WebApiModel(2087700490, "getAllSubtasks", typeSubtask);
  static const getAllComments =
      WebApiModel(148484683, "getAllComments", typeComment);
  static const searchTasks = WebApiModel(1468511716, "searchTasks", typeTask);
  static const getTask = WebApiModel(700738119, "getTask", typeTask);
  static const getTaskMetadata =
      WebApiModel(133280317, "getTaskMetadata", typeTaskMetadata);
  static const getProjectMetadata =
      WebApiModel(1797076613, "getProjectMetadata", typeProjectMetadata);
  static const typeProject = 0;
  static const typeBoard = 1;
  static const typeColumn = 2;
  static const typeTask = 3;
  static const typeSubtask = 4;
  static const typeComment = 5;
  static const typeProjectMetadata = 6;
  static const typeTaskMetadata = 7;

  const WebApiModel(this.apiId, this.apiName, this.apiType);

  final int apiId;
  final String apiName;
  final int apiType;
}
