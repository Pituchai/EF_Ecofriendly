// ignore_for_file: prefer_const_constructors
import 'package:comment_box/comment/test.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:navigate/pages/forum/questiondetailpage.dart';
import 'dart:convert';
import 'package:navigate/pages/forum/questionpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForumPage extends StatefulWidget {
  @override
  _ForumPageState createState() => _ForumPageState();
}
// username at most  12
//firstname at most 12 for each 12

class _ForumPageState extends State<ForumPage> {
  List<dynamic> questions = [];
  List<dynamic> number = [];

  @override
  void initState() {
    super.initState();
    fetchQuestions().then((data) {
      setState(() {
        questions = data;
      });
    }).catchError((error) {
      // Handle error
      print('Error: $error');
    });
  }

  void _goToQuestionPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QuestionForm()),
    );
  }

  Future<List<dynamic>> fetchQuestions() async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString("token");
    final uri = token != null
        ? Uri.parse("http://172.20.10.11:3000/questions/$token")
        : Uri.parse("http://172.20.10.11:3000/questions");

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to fetch questions');
    }
  }

  Future<void> incrementQuestionView(int index) async {
    final question = questions[index];
    final questionId =
        question['index_number']; // Assuming 'index_number' is the question ID

    final response = await http.put(
      Uri.parse('http://172.20.10.11:3000/questions/$questionId/view'),
    );
    if (response.statusCode == 200) {
      // Question view count incremented successfully
      setState(() {
        question['question_view'] += 1;
      });
    } else {
      // Handle error
      print('Error updating question view count');
    }
  }

  Future<String?> getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Return String
    String? stringValue = prefs.getString('token');
    return stringValue;
  }

  Future<void> likeQuestion(int index) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString("token");
    final question = questions[index];
    final questionId =
        question['index_number']; // Assuming 'index_number' is the question ID

    final isLiked = question['isLiked'] == 1;

    final updatedLikeValue = isLiked ? 0 : 1; // Toggle the like value
    print(question);

    final response = await http.post(
      Uri.parse(
          'http://172.20.10.11:3000/questions/$questionId/like/$token'), // Replace with your API endpoint to handle the like
      body: jsonEncode({
        'isLiked': updatedLikeValue,
      }), // Pass the updated like value in the request body
      headers: {'Content-Type': 'application/json'},

      // Add any required headers or body parameters for your API
    );

    if (response.statusCode == 200) {
      // Question liked successfully, update UI if needed
      final updatedQuestion = jsonDecode(response.body);
      // print("Updated Question: " + updatedQuestion);
      print(updatedQuestion);

      setState(() {
        questions[index] = updatedQuestion;
      });
    } else {
      // Handle error
      print('Error liking question');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(218, 251, 249, 1),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: Padding(
          padding: EdgeInsets.only(
              bottom: 10), // Adjust the padding values as needed
          child: AppBar(
            flexibleSpace: Container(
              decoration:
                  BoxDecoration(color: Color.fromARGB(255, 147, 230, 208)),
            ),
            actions: [
              FutureBuilder<String?>(
                future: getStringValuesSF(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return Column(
                      children: [
                        IconButton(
                          color: Colors.black,
                          icon: Icon(Icons.add),
                          onPressed: () {
                            _goToQuestionPage(context);
                          },
                        ),
                      ],
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final question = questions[index];
          final firstName = question['firstName'];
          final lastName = question['lastName'];
          final indexNumber = question['index_number'];
          final questionLike = question['question_like'];
          final questionView = question['question_view'];

          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuestionDetailsPage(
                        question: question,
                        firstName: firstName,
                        lastName: lastName,
                        indexNumber: indexNumber,
                        countable: questionLike,
                        countview: questionView,
                      ),
                    ),
                  );
                  incrementQuestionView(index);
                },
                child: Column(
                  children: [
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 80, 40),
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    "https://w7.pngwing.com/pngs/184/113/png-transparent-user-profile-computer-icons-profile-heroes-black-silhouette-thumbnail.png",
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  FutureBuilder<String?>(
                                    future: getStringValuesSF(),
                                    builder: (context, snapshot) {
                                      if (snapshot.data != null) {
                                        return Column(
                                          children: [
                                            Row(
                                              children: [
                                                IconButton(
                                                  color: Colors.black,
                                                  icon: Icon(
                                                    Icons.favorite,
                                                    color: question[
                                                                'isLiked'] ==
                                                            1
                                                        ? const Color.fromARGB(
                                                            255, 243, 33, 33)
                                                        : Colors.grey,
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      likeQuestion(index);
                                                    });
                                                  },
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 0, 10, 0),
                                                  child: Text(
                                                      'Like:  $questionLike'),
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                      } else {
                                        return Container();
                                      }
                                    },
                                  ),
                                  Icon(
                                    Icons.chat,
                                    size: 28,
                                    color: Colors.blue[200],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                              child: ListTile(
                                title: Text(
                                  '$firstName $lastName',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  question['question'],
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
