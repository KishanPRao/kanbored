import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_theme.dart';

void main() async {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppTheme(),
      builder: (context, _) => MaterialApp(
        title: 'Kanored',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: context.watch<AppTheme>().themeMode,
        home: const Home(),
      ),
    );
  }
}


class Home extends StatefulWidget {
  const Home({super.key});

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
      body: Column(
        children: [
          TextButton(
            onPressed: () => toggleTheme(),
            child: Text('Toggle Theme', style: TextStyle(
                color: context.theme.appColors.primary)),
          ),
        ],
      ),
    );
  }
}
