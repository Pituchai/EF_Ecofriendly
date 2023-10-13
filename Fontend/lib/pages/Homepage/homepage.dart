// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:navigate/pages/Homepage/page_body.dart';
import 'package:navigate/pages/profile/profile.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return page_body();
    // page_body();
  }
}
