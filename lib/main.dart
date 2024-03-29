import 'package:flutter/material.dart';
import 'package:kanbored/app_data.dart';
import 'package:kanbored/constants.dart';
import 'package:kanbored/pages/home.dart';
import 'package:kanbored/pages/login.dart';
import 'package:kanbored/pages/settings.dart';
import 'package:provider/provider.dart';
import 'app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppTheme.loadAllThemes();
  await AppData.initializeAppData();
  runApp(App());
}

class App extends StatelessWidget {
  App({super.key});
  final authenticated = AppData.authenticated;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppTheme(),
      builder: (context, _) => MaterialApp(
        title: 'Kanbored',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: context.watch<AppTheme>().themeMode,
        debugShowCheckedModeBanner: false,
        initialRoute: authenticated ? 'home' : 'login',
        routes: {
          routeHome: (BuildContext context) => const Home(title: 'Kanbored'),
          routeLogin: (BuildContext context) => Login(),
          routeSettings: (BuildContext context) => const SettingsUi(),
        },
      ),
    );
  }
}
