import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/app_data.dart';
import 'package:kanbored/constants.dart';
import 'package:kanbored/strings.dart';
import 'package:kanbored/ui/app_text_style.dart';
import 'package:kanbored/ui/app_theme.dart';
import 'package:kanbored/ui/ui_state.dart';
import 'package:kanbored/utils.dart';

class Settings extends ConsumerStatefulWidget {
  const Settings({super.key});

  @override
  ConsumerState<Settings> createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings> {
  var theme = AppData.theme;
  var apiUsername = AppData.getString(prefApiPassword, "");
  var apiToken = AppData.getString(prefApiPassword, "");
  var apiEndpoint = AppData.getString(prefApiUrl, "");

  // TODO: extract strings
  @override
  Widget build(BuildContext context) {
    return PopScope(
        onPopInvoked: (didPop) =>
            ref.read(UiState.boardEditing.notifier).state = false,
        child: Scaffold(
          backgroundColor: "pageBg".themed(context),
          appBar: AppBar(
            title: Text("settings".resc()),
            backgroundColor: "primary".themed(context),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          body: Column(
            children: [
              _buildSettingOption(context, "Theme", theme, _showThemeOptions),
              _buildSettingOption(
                  context,
                  "Logout",
                  "",
                  () => {
                        _showDialog("Logout?", null, (_) {
                          AppData.authenticated = false;
                          Navigator.pop(context); // Pop settings
                          Navigator.pop(context,
                              true); // Pop home screen; strange issue, only returns value using this
                        })
                      }),
            ],
          ),
        ));
  }

  void _showDialog(String title, String? content, Function cb) async {
    TextEditingController textFieldController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        Widget? contentWidget;
        if (content != null) {
          contentWidget = TextField(
            controller: textFieldController,
            decoration: InputDecoration(hintText: content),
          );
        }
        var dialog = AlertDialog(
          title: Text(title),
          content: contentWidget,
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                cb(textFieldController.text);
                Navigator.pop(context);
              },
            ),
          ],
        );
        return dialog;
      },
    );
  }

  void _showThemeOptions() async {
    var themes = ThemeMode.values.map((value) => value.name).toList();
    themes.add(themeAmolded);
    ref.read(themeProvider).themeMode = (await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text("select_theme".resc()),
            children: themes.map((value) {
              return SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, value);
                },
                child: Text(value.capitalize()),
              );
            }).toList(),
          );
        }))!;
    if (context.mounted) {
      setState(() {
        theme = ref.watch(themeProvider).themeMode;
      });
    }
  }

  InkWell _buildSettingOption(
      BuildContext context, String title, String value, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: AppTextStyle.settingsTitleFontSize,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              value,
              style: const TextStyle(
                  fontSize: AppTextStyle.settingsValueFontSize,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
