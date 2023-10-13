import 'package:flutter/material.dart';
import 'package:navigate/Splash/splash.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(128, 203, 196, 1),
        body: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
              child: Container(
                width: 500,
                height: 700,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(195, 255, 255, 255),
                  borderRadius:
                      BorderRadius.circular(15), // Adjust the radius as needed
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(
                          0.5), // Adjust the shadow color as needed
                      spreadRadius: 5, // Adjust the spread radius as needed
                      blurRadius: 7, // Adjust the blur radius as needed
                      offset:
                          Offset(0, 3), // Adjust the offset values as needed
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Image.asset(
                        'assets/images/logosustain.png', // Replace with the actual path or asset name of your image
                        width: 400, // Adjust the width as needed
                        height: 400, // Adjust the height as needed
                      ),
                    ),
                    const Text(
                      "Welcome to Eco-Friendy",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight:
                            FontWeight.bold, // Set the desired font weight
                      ),
                    ),
                    const Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Text(
                          "Let's get started",
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight:
                                FontWeight.bold, // Set the desired font weight
                          ),
                        )),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                        // ignore: sized_box_for_whitespace
                        child: Container(
                          width: 200, // Set the desired width
                          height: 50, // Set the desired height
                          child: FilledButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color.fromARGB(255, 0, 150,
                                      135)), // Set the button color here
                              iconColor: MaterialStateProperty.all<Color>(
                                  Colors.white), // Set the icon color here
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SplashScreen(),
                                ),
                              );
                            },
                            child: const Text("CONTINUE"),
                          ),
                        )),
                  ],
                ),
              )),
        ));
  }
}
