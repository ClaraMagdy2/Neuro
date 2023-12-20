import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'baby page.dart';
class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final _nameController = TextEditingController();
  final _birthdateController = TextEditingController();
  final _doctorController = TextEditingController();
  final _weightController = TextEditingController();

  // Replace with your Firebase Realtime Database URL
  final String firebaseUrl = 'https://clara1-a019a-default-rtdb.firebaseio.com/baby_info.json';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Admin Page Content'),
            TextField(controller: _nameController,
                decoration: const InputDecoration(labelText: 'Baby Name')),
            TextField(controller: _birthdateController,
                decoration: const InputDecoration(labelText: 'Birthdate')),
            TextField(controller: _doctorController,
                decoration: const InputDecoration(labelText: 'Doctor')),
            TextField(controller: _weightController,
                decoration: const InputDecoration(labelText: 'Birth Weight')),
            ElevatedButton(
              onPressed: () {
                _addBabyInformation();
              },
              child: const Text('Add Baby Information'),
            ),
            ElevatedButton(
              onPressed: () {
                _viewBabyInformation();
              },
              child: const Text('View Baby Information'),
            ),
            ElevatedButton(
              onPressed: () {
                _overrideBabyInformation();
              },
              child: const Text('edit Baby Information'),
            ),
            ElevatedButton(
              onPressed: () {
                _clearBabyInformation();
              },
              child: const Text('Clear Baby Information'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to sensor information page
                Navigator.pushNamed(context, '/sensor');
              },
              child: const Text('Sensor Information'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to stepper motor control page
                Navigator.pushNamed(context, '/stepper');
              },
              child: const Text('Stepper Motor Control'),
            ),
          ],
        ),
      ),
    );
  }

  void _addBabyInformation() async {
    try {
      var response = await http.post(
        Uri.parse(firebaseUrl),
        body: jsonEncode({
          'name': _nameController.text,
          'birthdate': _birthdateController.text,
          'doctor': _doctorController.text,
          'weight': _weightController.text,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Reset the controllers after successful addition
        _nameController.clear();
        _birthdateController.clear();
        _doctorController.clear();
        _weightController.clear();
        // Optionally, show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Baby information added successfully!'),
          ),
        );
      } else {
        // Handle error (show error message, etc.)
        print('Failed to add baby information. Server returned ${response
            .statusCode}');
      }
    } catch (e) {
      // Handle error (show error message, etc.)
      print('Error during adding baby information: $e');
    }
  }

  void _viewBabyInformation() {
    // Navigate to the view baby page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BabyInfoScreen()),
    );
  }


  void _overrideBabyInformation() async {
    try {
      var response = await http.get(Uri.parse(firebaseUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> babyInfoResponse = jsonDecode(response.body);

        if (babyInfoResponse.isNotEmpty) {
          // Get the last added baby information
          Map<String, dynamic> latestBabyInfo = babyInfoResponse.values.last;

          // Set the controllers with the latest added baby information
          _nameController.text = latestBabyInfo['name'];
          _birthdateController.text = latestBabyInfo['birthdate'];
          _doctorController.text = latestBabyInfo['doctor'];
          _weightController.text = latestBabyInfo['weight'];
        }
      } else {
        // Handle error (show error message, etc.)
        print('Failed to fetch baby information. Server returned ${response
            .statusCode}');
      }
    } catch (e) {
      // Handle error (show error message, etc.)
      print('Error during fetching baby information: $e');
    }
  }

  void _clearBabyInformation() async {
    try {
      var response = await http.delete(Uri.parse(firebaseUrl));

      if (response.statusCode == 200) {
        // Optionally, show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Baby information cleared successfully!'),
          ),
        );
      } else {
        // Handle error (show error message, etc.)
        print('Failed to clear baby information. Server returned ${response
            .statusCode}');
      }
    } catch (e) {
      // Handle error (show error message, etc.)
      print('Error during clearing baby information: $e');
    }
  }

}