import 'package:flutter/cupertino.dart';

abstract class EditableState<T extends StatefulWidget> extends State<T> {
  void endEdit(bool saveChanges);
  void delete();
}
