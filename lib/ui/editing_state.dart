import 'package:flutter/cupertino.dart';

abstract class EditableState<T extends StatefulWidget> extends State<T> {
  void startEdit() {}
  void endEdit(bool saveChanges);
  void delete();
}
