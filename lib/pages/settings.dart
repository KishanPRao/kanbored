import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kanbored/app_text_style.dart';
import 'package:kanbored/utils.dart';
import 'package:provider/provider.dart';
import 'package:kanbored/app_data.dart';
import 'package:kanbored/app_theme.dart';
import 'package:kanbored/constants.dart';

class SettingsUi extends StatefulWidget {
  const SettingsUi({super.key});

  @override
  State<StatefulWidget> createState() => SettingsUiState();
}

class SettingsUiState extends State<SettingsUi> {
  var theme = AppTheme.strToThemeMode(AppData.theme);
  var apiUsername = AppData.getString(prefApiPassword, "");
  var apiToken = AppData.getString(prefApiPassword, "");
  var apiEndpoint = AppData.getString(prefApiUrl, "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: context.theme.appColors.primary,
        leading: IconButton(
          onPressed: () => {Navigator.pop(context)},
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          buildSettingOption(context, "Theme", AppTheme.themeModeToStr(theme),
              _showThemeOptions),
          buildSettingOption(
              context,
              "API Token",
              apiToken,
              () => _showDialog("API Token", "Enter the API Token", (token) {
                    AppData.setString(prefApiPassword, token);
                    setState(() {
                      apiToken = token;
                    });
                  })),
          buildSettingOption(
              context,
              "API Endpoint",
              apiEndpoint,
              () => _showDialog("API Endpoint", "Enter the API Endpoint",
                      (endpoint) {
                    AppData.setString(prefApiUrl, endpoint);
                    setState(() {
                      apiEndpoint = endpoint;
                    });
                  })),
        ],
      ),
    );
  }

  void _showDialog(String title, String content, Function cb) async {
    TextEditingController textFieldController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: textFieldController,
            decoration: InputDecoration(hintText: content),
          ),
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
      },
    );
  }

  void _showThemeOptions() async {
    context.read<AppTheme>().themeMode = (await showDialog<ThemeMode>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select theme'),
            children: ThemeMode.values.map((value) {
              return SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, value);
                },
                child: Text(value.name.capitalize()),
              );
            }).toList(),
          );
        }))!;
    if (context.mounted) {
      setState(() {
        theme = context.read<AppTheme>().themeMode;
      });
    }
  }

  InkWell buildSettingOption(
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
