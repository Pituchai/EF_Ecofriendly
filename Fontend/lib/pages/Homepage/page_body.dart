// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, camel_case_types
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:navigate/pages/Homepage/detailpage.dart';
import 'package:http/http.dart' as http;

class page_body extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  page_body({Key? key});
  @override
  State<page_body> createState() => _page_bodyState();
}

class _page_bodyState extends State<page_body> {
  List<dynamic> sustainData = [];

  List<Map> announcementTags = [
    {
      'image': 'assets/images/Eco Friendly.png',
      'title': 'Sustainable products',
    },
    {
      'image': 'assets/images/SDG.png',
      'title': 'Sustainable Development Goals',
    },
    {
      'image': 'assets/images/SDG_meets.png',
      'title': 'Sustainable Development Goals',
    },
  ];

  @override
  void initState() {
    super.initState();
    fetchSustainData();
  }

  Future<void> fetchSustainData() async {
    final response =
        await http.get(Uri.parse('http://172.20.10.11:3000/sustain'));

    if (response.statusCode == 200) {
      final body = response.body;
      if (body != null && body.isNotEmpty) {
        final data = json.decode(body);
        setState(() {
          sustainData = data;
        });
      } else {
        print('Empty response body');
      }
    } else {
      print(
          'Failed to fetch sustain data. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 50, bottom: 15),
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: const [
                          Text(
                            "WELCOME",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      Center(
                        child: Container(
                          width: 45,
                          height: 45,
                          child: Icon(
                            Icons.home,
                            color: Colors.white,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.teal[200],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // _pages[_selectedIndex],
              ],
            ),
          ),
          Container(
            height: 250,
            child: PageView.builder(
              itemCount: announcementTags.length,
              itemBuilder: (context, index) {
                return _buildPageItem(index);
              },
            ),
          ),

          // part to count the picture
          Container(
            //Body of the page, where the pic and the text are!
            height: 700,
            child: ListView.builder(
              itemCount: sustainData.length,
              itemBuilder: (context, index) {
                final item = sustainData[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(
                          item: item != null && item['p_name'] != null
                              ? item['p_name']
                              : 'N/A',
                          item2: item != null && item['p_cat'] != null
                              ? item['p_cat']
                              : 'N/A',
                          item3: item != null && item['p_mat'] != null
                              ? item['p_mat']
                              : 'N/A',
                          item4: item != null && item['p_price'] != null
                              ? item['p_price']
                              : 'N/A',
                          item5: item != null && item['p_decomp_time'] != null
                              ? item['p_decomp_time']
                              : 'N/A',
                          item6: item != null && item['p_pic'] != null
                              ? item['p_pic']
                              : 'N/A',
                          item7: item != null && item['p_detail'] != null
                              ? item['p_detail']
                              : 'N/A',
                          item8: item != null && item['p_ref'] != null
                              ? item['p_ref']
                              : 'N/A',
                        ),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Container(
                      height: 120, // Set the desired height here
                      child: Card(
                        elevation: 4,
                        margin: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: AspectRatio(
                                aspectRatio:
                                    1.2, // Adjust the aspect ratio as needed
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color.fromARGB(0, 5, 185,
                                          173), // Set the border color
                                      width: 2, // Set the border width
                                    ),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        item != null && item['p_pic'] != null
                                            ? item['p_pic']
                                            : '',
                                      ),
                                      // fit: BoxFit.cover, // Adjust the fit as needed
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      item['p_name'] ?? '',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          8, // Add spacing between the texts
                                    ),
                                    Text(
                                      'Category: ${item['p_cat'] ?? ''}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          )

          // DetailPage(item: item.toString())
          // ------------------------------
        ],
      ),
    );
  }

  Widget _buildPageItem(int index) {
    return GestureDetector(
      child: Stack(
        children: [
          Container(
            height: 220,
            margin: EdgeInsets.only(left: 5, right: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: index.isEven ? Colors.white : Colors.white,
              image: DecorationImage(
                image: AssetImage(announcementTags[index]['image']),
                // fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 40,
            right: 40,
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: index.isEven ? Colors.teal[200] : Colors.teal[200],
              ),
              // Add your text widget here
              child: Center(
                child: Text(
                  announcementTags[index]['title'],
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
