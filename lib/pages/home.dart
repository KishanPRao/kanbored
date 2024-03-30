import 'package:flutter/material.dart';
import 'package:kanbored/app_theme.dart';
import 'package:kanbored/app_data.dart';
import 'package:kanbored/constants.dart';
import 'package:kanbored/pages/login.dart';
import 'package:kanbored/pages/settings.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Map<String, dynamic> loginData = {
    'username': AppData.username,
    'password': AppData.password,
    'url': AppData.url,
    'authenticated': AppData.authenticated
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: context.theme.appColors.primary,
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.pushNamed(context, routeSettings).then((value) {
                if (value?.runtimeType == bool) {
                  Navigator.pushNamed(context, routeLogin);
                }
              }
              );
            },
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
