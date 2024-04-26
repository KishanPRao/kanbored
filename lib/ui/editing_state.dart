import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class EditableState<T extends ConsumerStatefulWidget>
    extends ConsumerState<T> {
  void startEdit() {}

  void endEdit(bool saveChanges);

  void delete() {}

  void archive() {}

  void unarchive() {}

  static GlobalKey<EditableState> createKey() => GlobalKey<EditableState>();
}
