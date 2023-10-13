// ignore_for_file: prefer_const_constructors
import 'dart:math';
// error with navigate to splash screen
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:navigate/Splash/splash02.dart';
import 'package:navigate/pages/forum/form.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestionForm extends StatefulWidget {
  const QuestionForm({Key? key}) : super(key: key);

  @override
  _QuestionFormState createState() => _QuestionFormState();
}

class _QuestionFormState extends State<QuestionForm> {
  final TextEditingController _questionController = TextEditingController();
  String _firstName = '';
  String _lastName = '';

  Future<void> sendQuestion(String question) async {
    final Random random = Random();
    final int index = random.nextInt(10000); // Generate a random index
    final Uri uri = Uri.parse('http://172.20.10.11:3000/questions');
    final http.Response response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body:
          '{"question": "$question","index": "$index","firstName": "$_firstName","lastName": "$_lastName"}',
    );

    if (response.statusCode == 200) {
      print('Question added with index: $index');
      // _navigateToSplashScreen();
    } else {
      print('Failed to add question');
    }
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

  @override
  void initState() {
    super.initState();
    _getFirstNameAndLastName();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 5, 185, 173),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
          child: Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                color: Color.fromARGB(255, 255, 255, 255),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForumPage()),
                          );
                        },
                      ),
                      Text(
                        '$_firstName $_lastName',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: TextField(
                            controller: _questionController,
                            decoration: InputDecoration(
                              labelText: 'Enter your question',
                              labelStyle: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 2.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 2.0,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 16.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final String question = _questionController.text;
                          sendQuestion(question);
                          _questionController.clear();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (ctx) => const Splash()),
                          );
                        },
                        child: Text('Submit'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }
}
