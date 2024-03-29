import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kanbored/app_theme.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("Login"),
          backgroundColor: context.theme.appColors.primary,
        ),
        body: Column(
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
                });
              },
              child: Text('Toggle Theme',
                  style: TextStyle(color: context.theme.appColors.primary)),
            ),
          ],
        ));
  }
}
