import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/api/api.dart';
import 'package:kanbored/api/web_api.dart';
import 'package:kanbored/app_data.dart';
import 'package:kanbored/constants.dart';
import 'package:kanbored/db/database.dart';
import 'package:kanbored/pages/board.dart';
import 'package:kanbored/pages/home.dart';
import 'package:kanbored/pages/login.dart';
import 'package:kanbored/pages/search.dart';
import 'package:kanbored/pages/settings.dart';
import 'package:kanbored/pages/task.dart';
import 'package:kanbored/strings.dart';
import 'package:kanbored/ui/app_theme.dart';

Future<void> deleteEverything() async {
  final database = AppDatabase();
  await database.customStatement('PRAGMA foreign_keys = OFF');
  try {
    await database.transaction(() async {
      for (final table in database.allTables) {
        await database.delete(table).go();
      }
    });
  } finally {
    await database.customStatement('PRAGMA foreign_keys = ON');
  }
  database.close();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppTheme.initialize();
  await AppData.initialize();
  await Strings.initialize();

  // WebApi.getTaskMetadata(44).then((value) {
  //   log("task META: $value");
  // });
  runApp(ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  App({super.key});

  final authenticated = AppData.authenticated;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider).themeMode;
    return MaterialApp(
      title: "app_name".resc(),
      theme: AppTheme.light,
      darkTheme:
          AppData.theme == themeAmolded ? AppTheme.amolded : AppTheme.dark,
      themeMode: AppTheme.strToThemeMode(themeMode),
      debugShowCheckedModeBanner: false,
      initialRoute: authenticated ? 'home' : 'login',
      // TODO: re-use pages
      routes: {
        routeHome: (BuildContext context) => const Home(),
        routeLogin: (BuildContext context) => const Login(),
        routeBoard: (BuildContext context) => const Board(),
        routeSettings: (BuildContext context) => const Settings(),
        routeTask: (BuildContext context) => const Task(),
        routeSearch: (BuildContext context) => const Search(),
      },
    );
  }
}
