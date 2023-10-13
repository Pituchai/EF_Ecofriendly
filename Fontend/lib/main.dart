import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:navigate/Navigate/navigation.dart';
import 'package:navigate/Splash/splash.dart';
import 'package:navigate/introduction.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

bool? seenOnboard;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // to show status bar
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  // to load onboard for the first time only
  SharedPreferences pref = await SharedPreferences.getInstance();
  seenOnboard = pref.getBool('seenOnboard') ?? false; //if null set to false

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(),
      // home: BottomNavigationBarExampleApp(),
      // home: SplashScreen(),
      home: seenOnboard == true ? SplashScreen() : MyWidget(),
    );
  }
}
//comment anf id question