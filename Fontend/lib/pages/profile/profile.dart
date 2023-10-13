import 'package:flutter/material.dart';
import 'package:navigate/pages/Login/login.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: Center(child: LoginForm()),
    );
  }
}
