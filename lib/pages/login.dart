import 'package:flutter/material.dart';
import 'package:kanbored/api/api.dart';
import 'package:kanbored/app_data.dart';
import 'package:kanbored/constants.dart';
import 'package:kanbored/strings.dart';
import 'package:kanbored/ui/sizes.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String url = AppData.url;
  String username = AppData.username;
  String password = AppData.password;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: "screenBg".themed(context),
        appBar: AppBar(
          title: const Text("Login"),
          backgroundColor: "primary".themed(context),
        ),
        body: Form(
            key: _formKey,
            child: Column(children: [
              const SizedBox(height: Sizes.kLoginUrlPadding),
              _createField(
                  AppData.url,
                  Icons.cloud,
                  'https://kanboard_url.com',
                  'Kanboard URL',
                  'Must specify an URL!',
                  false,
                  (value) => url = value),
              const SizedBox(height: Sizes.kLoginPasswordPadding),
              _createField(
                  AppData.username,
                  Icons.person,
                  'admin',
                  'Username',
                  'Must specify an username!',
                  false,
                  (value) => username = value),
              const SizedBox(height: Sizes.kLoginUsernamePadding),
              _createField(
                  AppData.password,
                  Icons.lock,
                  'hunter2',
                  'Password',
                  'Must specify an password!',
                  true,
                  (value) => password = value),
              const SizedBox(height: Sizes.kLoginPasswordPadding),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _showLoaderDialog(context);
                    Api.login(url, username, password).then((value) {
                      Navigator.pop(context); // dialog
                      setState(() {
                        Navigator.pop(context); // login
                        Navigator.pushNamed(context, routeHome);
                      });
                    }).onError((e, st) {
                      Navigator.pop(context); // dialog
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text("Error: $e")));
                      return Future.error(
                          Error()); // TODO: Handle error when wrong URL etc!
                    });
                  }
                },
                child: Text('LOGIN',
                    style: TextStyle(color: "primary".themed(context))),
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
            icon: Icon(icon, color: "primary".themed(context)),
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

  _showLoaderDialog(BuildContext context) {
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
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
