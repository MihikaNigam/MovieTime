import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mymovietime/authentication/google_login_provider.dart';
import 'package:mymovietime/utils/app_color.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isClicked = false;
  int tapcount = 0;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 50),
          color: AppColor.peach,
          child: Column(
            children: [
              Spacer(),
              Center(
                child: Text(
                  'Welcome to Movie Time !',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              Spacer(),
              ElevatedButton.icon(
                  icon: FaIcon(
                    FontAwesomeIcons.google,
                    color: Colors.white,
                  ),
                  label: Text(
                    '    Sign In with Google',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 10,
                    onPrimary: AppColor.black,
                    onSurface: AppColor.black,
                    shape: StadiumBorder(),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  onPressed: () {
                    Provider.of<GoogleSignInProvider>(context, listen: false)
                        .login();
                  }),
            ],
          )),
    );
  }
}
