// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:navigate/Navigate/navigation.dart';
import 'package:navigate/Splash/splash.dart';
import 'package:navigate/pages/Homepage/homepage.dart';
import 'package:navigate/pages/Login/subcribe.dart';
import 'package:navigate/pages/Register/register.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
  bool get isTokenEmpty => _LoginFormState()._token.isEmpty;
}

class _LoginFormState extends State<LoginForm> {
  String _firstName = ''; // Declare this variable
  String _lastName = ''; // Declare this variable
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';
  String _token = '';
  final storage = FlutterSecureStorage();
  int _selectedIndex = 0;

  Future<void> _login() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    final Map<String, String> data = {
      'username': username,
      'password': password,
    };
    final Uri uri = Uri.parse('http://172.20.10.11:3000/login');
    final http.Response response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );
    final Map<String, dynamic> responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final String token = responseData['token'];
      final String firstName = responseData['firstName'];
      final String lastName = responseData['lastName'];
      setState(() {
        _token = token;
        _firstName = firstName;
        _lastName = lastName;
        _errorMessage = '';
        addStringToSF(_token, _firstName, _lastName);
        _navigateToSplashScreen();
      });
    } else {
      final String error = responseData['error'];
      setState(() {
        _token = '';
        _errorMessage = error;
      });
    }
  }

  addStringToSF(String token, String firstName, String lastName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    prefs.setString('firstName', firstName);
    prefs.setString('lastName', lastName);
  }

  void _navigateToSplashScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => SplashScreen(),
      ),
    );
  }

  removeValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Remove String
    prefs.remove("token");
    prefs.remove("firstName");
    prefs.remove("lastName");
  }

  void _Register() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterForm()),
    );
  }

  Future<void> _logout() async {
    // Clear the token and perform any necessary logout logic
    await storage.delete(key: 'token');

    setState(() {
      _token = '';
    });

    final Uri uri = Uri.parse('http://172.20.10.11:3000/logout');
    final http.Response response = await http.post(uri);

    // Perform any necessary error handling or post-logout logic
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String message = responseData['message'];
      print('Logout: $message');
      removeValues();
      _navigateToSplashScreen();
    } else {
      print('Logout failed');
    }
  }

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    setState(() {
      _token = token ?? '';
    });

    return token;
  }

  @override
  void initState() {
    super.initState();
    _getToken().then((String? token) {
      setState(() {
        _token = token ?? '';
        _getFirstNameAndLastName(); // Call the method to retrieve firstName and lastName
      });
    });
  }

  Future<void> _getFirstNameAndLastName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? firstName = prefs.getString('firstName');
    String? lastName = prefs.getString('lastName');

    setState(() {
      _firstName = firstName ?? '';
      _lastName = lastName ?? '';
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      _logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _token.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Positioned(
                    top: 20,
                    left: 20,
                    right: 20,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BottomNavigationBarExampleApp(),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.close,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        "Welcome Back",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "GO GREEN!",
                        style: TextStyle(
                          color: Color.fromARGB(184, 5, 185, 173),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            hintText: "Username",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none,
                            ),
                            fillColor: Theme.of(context)
                                .primaryColorDark
                                .withOpacity(0.1),
                            filled: true,
                            prefixIcon: Icon(Icons.email_rounded),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            hintText: "Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none,
                            ),
                            fillColor: Theme.of(context)
                                .primaryColorDark
                                .withOpacity(0.1),
                            filled: true,
                            prefixIcon: Icon(Icons.key),
                          ),
                          obscureText: true,
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: _login,
                          child: Text(
                            "Login",
                            style: TextStyle(fontSize: 20),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: StadiumBorder(),
                            padding: EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Color.fromARGB(184, 12, 230, 215),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: _Register,
                          child: Text(
                            "Register",
                            style: TextStyle(fontSize: 20),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: StadiumBorder(),
                            padding: EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Color.fromARGB(184, 12, 230, 215),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 150, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(270, 0, 0, 0),
                      child: Container(
                        width: 100,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.teal[200],
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'SUBSCRIBE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(
                            "https://w7.pngwing.com/pngs/184/113/png-transparent-user-profile-computer-icons-profile-heroes-black-silhouette-thumbnail.png",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      '$_firstName $_lastName',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    if (_token.isNotEmpty)
                      IconButton(
                        icon: Icon(Icons.logout),
                        onPressed: _logout,
                      ),
                    SizedBox(
                      width: 400,
                      child: ElevatedButton(
                        child: Text("Subscribe"),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.teal[200],
                          elevation: 0,
                        ),
                        onPressed: () {
                          // Navigate to the subscribe page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SubscribePage()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
