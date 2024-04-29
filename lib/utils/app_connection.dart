import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:kanbored/api/api.dart';
import 'package:kanbored/utils/app_data.dart';
import 'package:riverpod/src/state_controller.dart';

class AppConnection {
  late StreamSubscription<List<ConnectivityResult>> subscription;

  void updateConnection(StateController<bool?> onlineStatus) async {
    try {
      final address = AppData.url.isNotEmpty ? AppData.url : 'example.com';
      var result = await http.get(Uri.parse(address)).timeout(
            const Duration(seconds: 1),
            onTimeout: () => http.Response('Error', 408),
          );
      if (result.statusCode == 200) {
        onlineStatus.state = true;
      } else {
        onlineStatus.state = false;
      }
    } on SocketException catch (e) {
      onlineStatus.state = false;
      // log('not connected: $e');
    }
  }

  AppConnection(StateController<bool?> onlineStatus) {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      log("connection updated");
      updateConnection(onlineStatus);
    });
    Api.recurringApi(seconds: 5, () async {
      updateConnection(onlineStatus);
    });
  }

  void dispose() {
    // subscription.cancel();
  }
}
