import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SustainDataPage extends StatefulWidget {
  @override
  _SustainDataPageState createState() => _SustainDataPageState();
}

class _SustainDataPageState extends State<SustainDataPage> {
  List<dynamic> sustainData = [];

  @override
  void initState() {
    super.initState();
    fetchSustainData();
  }

  Future<void> fetchSustainData() async {
    final response = await http.get(Uri.parse('http://localhost:3000/sustain'));

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Sustain Data'),
      ),
      body: ListView.builder(
        itemCount: sustainData.length,
        itemBuilder: (context, index) {
          final item = sustainData[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(item['p_pic'] ?? ''),
            ),
            title: Text(item['p_name'] ?? ''),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Category: ${item['p_cat'] ?? ''}'),
                Text('Material: ${item['p_mat'] ?? ''}'),
                Text('Price: ${item['p_price'] ?? ''}'),
                Text('Decomposition Time: ${item['p_decomp_time'] ?? ''}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
