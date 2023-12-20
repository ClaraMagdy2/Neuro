import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: const LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _userType = 'user';

  Future<void> _login() async {
    try {
      var url = Uri.parse('https://clara1-a019a-default-rtdb.firebaseio.com/users.json');

      var response = await http.get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> users = jsonDecode(response.body);

        // Iterate through all users
        users.forEach((userId, userData) {
          // Check if username and password match
          if (userData['username'] == _usernameController.text.trim() &&
              userData['password'] == _passwordController.text) {
            _userType = userData['userType'];

            if (_userType == 'admin') {
              Navigator.pushNamed(context, '/admin');
            } else {
              Navigator.pushNamed(context, '/user');
            }
          }
        });

        // If no matching user is found
        print('Invalid username or password');
      } else {
        // Handle the case where the server response is not 200 OK
        print('Server returned ${response.statusCode}');
      }
    } catch (e) {
      // Handle other exceptions
      print('Error: $e');
    }
  }


  void _goToSignUp() {
    Navigator.pushNamed(context, '/signup'); // Navigate to the signup screen
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(controller: _usernameController, decoration: const InputDecoration(labelText: 'Username')),
          TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('User Type: '),
              Radio(value: 'user', groupValue: _userType, onChanged: (value) => setState(() => _userType = value as String)),
              const Text('User'),
              Radio(value: 'admin', groupValue: _userType, onChanged: (value) => setState(() => _userType = value as String)),
              const Text('Admin'),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _login, child: const Text('Login')),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _goToSignUp,
            child: const Text("Don't have an account? Sign Up"),
          ),
        ],
      ),
    );
  }
}
