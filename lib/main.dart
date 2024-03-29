import 'package:flutter/material.dart';
import 'package:kanbored/app_data.dart';
import 'package:kanbored/pages/login.dart';
import 'package:kanbored/pages/settings.dart';
import 'package:provider/provider.dart';
import 'app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppTheme.loadAllThemes();
  await AppData.loadSharedPreferences();
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
          'home': (BuildContext context) => const Home(title: 'Kanbored'),
          'login': (BuildContext context) => Login(),
        },
      ),
    );
  }
}

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
    'endpoint': AppData.endpoint,
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsUi()),
                );
              },
              icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: Column(
        children: [
        ],
      ),
    );
  }
}
