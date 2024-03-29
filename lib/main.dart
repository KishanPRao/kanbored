import 'package:flutter/material.dart';
import 'package:kanbored/app_data.dart';
import 'package:kanbored/settings_ui.dart';
import 'package:provider/provider.dart';
import 'app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppTheme.loadAllThemes();
  await AppData.loadSharedPreferences();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

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
        home: const Home(title: 'Kanbored'),
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
  void updateThemeMode(ThemeMode themeMode) {
    context.read<AppTheme>().themeMode = themeMode;
  }

  void toggleTheme() {
    var newTheme = ThemeMode.light;
    if (context.read<AppTheme>().themeMode == ThemeMode.light) {
      newTheme = ThemeMode.dark;
    }
    updateThemeMode(newTheme);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
          TextButton(
            onPressed: () => toggleTheme(),
            child: Text('Toggle Theme',
                style: TextStyle(color: context.theme.appColors.primary)),
          ),
        ],
      ),
    );
  }
}
