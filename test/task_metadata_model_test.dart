import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kanbored/pages/main.dart';
import 'package:kanbored/models/task_metadata_model.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // TODO:
    var srcJson = "";
    var taskMetadataModel = taskMetadataModelFromJson(srcJson);
    var taskMetadataModelJson = taskMetadataModelToJson(taskMetadataModel);
    expect(srcJson, taskMetadataModelJson);
  });
}
