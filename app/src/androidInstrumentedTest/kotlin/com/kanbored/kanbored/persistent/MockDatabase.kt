package com.kanbored.kanbored.persistent

class MockDatabase : KanbanDatabase {
    override fun projectDao(): KanbanProjectDao = MockKanbanProjectDao

    override fun columnDao(): KanbanColumnDao = MockKanbanColumnDao

    override fun taskDao(): KanbanTaskDao = MockKanbanTaskDao

    override fun subtaskDao(): KanbanSubtaskDao = MockKanbanSubtaskDao

    override fun commentDao(): KanbanCommentDao = MockKanbanCommentDao

    override fun apiStorageDao(): ApiStorageDao = MockApiStorageDao

    fun clear() {
        MockKanbanProjectDao.clear()
        MockKanbanColumnDao.clear()
        MockKanbanTaskDao.clear()
        MockKanbanSubtaskDao.clear()
        MockKanbanCommentDao.clear()
        MockApiStorageDao.clear()
    }
}