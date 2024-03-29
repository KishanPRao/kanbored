import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kanbored/api/authenticator.dart';
import 'package:kanbored/app_data.dart';
import 'package:kanbored/app_theme.dart';
import 'package:kanbored/constants.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<Login> {
  String url = AppData.url;
  String username = AppData.username;
  String password = AppData.password;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
          backgroundColor: context.theme.appColors.primary,
        ),
        body: Form(
            key: _formKey,
            child: Column(children: [
              const SizedBox(height: 20.0),
              _createField(
                  AppData.url,
                  Icons.cloud,
                  'https://kanboard_url',
                  'Kanboard URL',
                  'Must specify an URL!',
                  false,
                  (value) => url = value),
              const SizedBox(height: 10.0),
              _createField(
                  AppData.username,
                  Icons.person,
                  'admin',
                  'Username',
                  'Must specify an username!',
                  false,
                  (value) => username = value),
              const SizedBox(height: 10.0),
              _createField(
                  AppData.password,
                  Icons.lock,
                  'hunter2',
                  'Password',
                  'Must specify an password!',
                  true,
                  (value) => password = value),
              const SizedBox(height: 25.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    showLoaderDialog(context);
                    print("login: $url, $username, $password");
                    Authenticator.login(url, username, password).then((value) {
                      Navigator.pop(context);
                      setState(() {
                        Navigator.pushNamedAndRemoveUntil(
                            context, routeHome, (route) => false);
                      });
                    }).onError((e, st) {
                      Navigator.pop(context);
                      print("Err: $e");
                      // print("Err: ${(e as dynamic)['message']}");
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              Text("Error: $e")));
                      // SnackBar(content: Text("Error"));
                      return Future.error(
                          Error()); // TODO: Handle error when wrong URL etc!
                      // return null;
                      // return false;
                    });
                  }
                },
                child: Text('LOGIN',
                    style: TextStyle(color: context.theme.appColors.primary)),
              ),
            ])));
  }

  Widget _createField(String initValue, IconData icon, String hintText,
      String lblText, String errorText, bool obscureText, Function(String) cb) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
          initialValue: initValue,
          obscureText: obscureText,
          decoration: InputDecoration(
            icon: Icon(icon, color: context.theme.appColors.primary),
            hintText: hintText,
            labelText: lblText,
          ),
          onChanged: cb,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return errorText;
            }
            return null;
          }),
    );
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: 20),
              child: const Text("Logging in...")),
        ],
      ),
    );
    showDialog(
      // TODO: undo
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
