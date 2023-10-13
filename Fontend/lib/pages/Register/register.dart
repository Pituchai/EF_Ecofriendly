// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:navigate/Splash/splash.dart';
import 'package:navigate/pages/Login/login.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _register() async {
    final String firstname = _firstnameController.text;
    final String lastname = _lastnameController.text;
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    final Map<String, String> data = {
      'firstname': firstname,
      'lastname': lastname,
      'username': username,
      'password': password,
    };
    if (password.length < 8) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Invalid Password'),
          content: Text('Password must be at least 8 characters long.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final Uri uri = Uri.parse('http://172.20.10.11:3000/register');
    final http.Response response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      // Registration successful
      print('Registration successful');
      _Register();
    } else {
      // Registration failed
      print('Registration failed');
    }
  }

  void _Register() {
    Navigator.pop(
      context,
      MaterialPageRoute(builder: (context) => LoginForm()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Positioned(
                      top: 10,
                      left: 20,
                      right: 20,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginForm()),
                              );
                            },
                            icon: Icon(
                              Icons.close,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      )),
                  Text(
                    "Let's Register",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "GO GREEN!",
                    style: TextStyle(color: Color.fromARGB(184, 5, 185, 173)),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _firstnameController,
                    decoration: InputDecoration(
                      hintText: "Firstname",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                      fillColor:
                          Theme.of(context).primaryColorDark.withOpacity(0.1),
                      filled: true,
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _lastnameController,
                    decoration: InputDecoration(
                      hintText: "Lastname",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                      fillColor:
                          Theme.of(context).primaryColorDark.withOpacity(0.1),
                      filled: true,
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: "Username",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                      fillColor:
                          Theme.of(context).primaryColorDark.withOpacity(0.1),
                      filled: true,
                      prefixIcon: Icon(Icons.email_rounded),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                      fillColor:
                          Theme.of(context).primaryColorDark.withOpacity(0.1),
                      filled: true,
                      prefixIcon: Icon(Icons.key),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _register,
                    child: Text(
                      "Register!",
                      style: TextStyle(fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Color.fromARGB(184, 12, 230, 215),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
