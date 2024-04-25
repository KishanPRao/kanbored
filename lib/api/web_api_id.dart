enum WebApiId {
  createProject(1797076613),
  addColumn(638544704),
  createTask(1176509098),
  createSubtask(2041554661),
  createComment(1580417921),
  saveProjectMetadata(1797076613),
  saveTaskMetadata(133280317),

  updateProject(1853996288),
  updateColumn(480740641),
  updateTask(1406803059),
  updateComment(496470023),
  updateSubtask(191749979),
  enableProject(1775494839),
  disableProject(1734202312),
  openTask(1888531925),
  closeTask(1654396960),

  removeProject(46285125),
  removeColumn(1433237746),
  removeTask(1423501287),
  removeComment(328836871),
  removeSubtask(1382487306),

  // getAllProjects(2134420212),
  // getBoard(827046470),
  // getColumns(887036325),
  // getAllTasks(133280317),
  // getAllSubtasks(2087700490),
  // getAllComments(148484683),
  //
  // searchTasks(1468511716),
  // getTask(700738119),
  // getTaskMetadata(133280317),
  // getProjectMetadata(1797076613),
  ;
  const WebApiId(this.value);
  final int value;
}