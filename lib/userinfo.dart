import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class userinfo extends StatefulWidget {
  @override
  _BabyInfoScreenState createState() => _BabyInfoScreenState();
}

class _BabyInfoScreenState extends State<userinfo> {
  String databaseUrl = "https://clara1-a019a-default-rtdb.firebaseio.com/baby_info.json";
  List<Map<String, dynamic>> babyList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(databaseUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        data.forEach((key, value) {
          babyList.add({
            'key': key,
            'name': value['name'],
            'birthdate': value['birthdate'],
            'doctor': value['doctor'],
            'weight': value['weight'],
          });
        });

        setState(() {});
      } else {
        print("Failed to load data: ${response.statusCode}");
      }
    } catch (error) {
      print("Error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Baby Info'),
      ),
      body: ListView.builder(
        itemCount: babyList.length,
        itemBuilder: (context, index) {
          final baby = babyList[index];
          return ListTile(
            title: Text(baby['name']),
            subtitle: Text('Birthdate: ${baby['birthdate']}\nDoctor: ${baby['doctor']}\nWeight: ${baby['weight']} '),
          );
        },
      ),
    );
  }
}

