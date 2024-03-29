import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kanbored/app_text_style.dart';
import 'package:kanbored/utils.dart';
import 'package:provider/provider.dart';

import 'app_data.dart';
import 'app_theme.dart';

class SettingsUi extends StatefulWidget {
  const SettingsUi({super.key});

  @override
  State<StatefulWidget> createState() => SettingsUiState();
}

class SettingsUiState extends State<SettingsUi> {
  var theme =
      AppTheme.strToThemeMode(AppData.getString(AppData.prefTheme, "system"));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        leading: IconButton(
          onPressed: () => {Navigator.pop(context)},
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          buildSettingOption(context, "Theme", AppTheme.themeModeToStr(theme),
              () async {
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
          })
        ],
      ),
    );
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
