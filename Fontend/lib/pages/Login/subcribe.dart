import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SubscribePage extends StatelessWidget {
  const SubscribePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> str = [
      "Categorized Products",
      "Ads Free",
      "many more features in the future."
    ];
    // Replace this with your payment details
    final String paymentDetails = 'Your Payment Details';

    return Scaffold(
      backgroundColor: Color.fromRGBO(218, 251, 249, 1),
      appBar: AppBar(
        toolbarHeight: 100,
        flexibleSpace: Container(
          decoration: BoxDecoration(color: Color.fromARGB(255, 147, 230, 208)),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
// Support us and convenience yourself for just $2.99
            Text(
              'Coming Soon!',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              ' What would user get?',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            Center(
              child: Container(
                padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                child: Column(
                  children: str.map((strone) {
                    return Row(children: [
                      Text(
                        "\u2022",
                        style: TextStyle(fontSize: 20),
                      ), //bullet text
                      SizedBox(
                        width: 10,
                      ), //space between bullet and text
                      Expanded(
                        child: Text(
                          strone,
                          style: TextStyle(fontSize: 20),
                        ), //text
                      )
                    ]);
                  }).toList(),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              'Support us and convenience yourself for just \$2.99',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 50,
            ),
            SizedBox(
              width: 400,
              child: ElevatedButton(
                child: Text("Subscribe"),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 32, 177, 138),
                  elevation: 0,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Subscription Confirmation'),
                        content: Text('Are you sure you want to subscribe?'),
                        actions: [
                          TextButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                          ),
                          TextButton(
                            child: Text('Subscribe'),
                            onPressed: () {
                              // Perform subscription logic here
                              // ...
                              Navigator.pop(context); // Close the dialog
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
