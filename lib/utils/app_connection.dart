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
  var retryCount = 0;

  void updateConnection(StateController<bool?> onlineStatus) async {
    try {
      final address = AppData.url.isNotEmpty ? AppData.url : 'example.com';
      var result = await http.get(Uri.parse(address)).timeout(
            const Duration(seconds: 4),
            onTimeout: () => http.Response('Error', 408),
          );
      // log("update connection: ${result.statusCode}, $address");
      if (result.statusCode == 200) {
        retryCount = 0;
        onlineStatus.state = true;
      } else if (result.statusCode == 408 && retryCount < 3) {  /* request timeout */
        retryCount++;
        // log("update connection: retry: $retryCount");
      } else {
        log("update connection: retry offline: $retryCount");
        retryCount = 0;
        onlineStatus.state = false;
      }
    } on SocketException catch (e) {
      onlineStatus.state = false;
      log('not connected: $e');
    }
    // log("update connection status: ${onlineStatus.state}");
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
