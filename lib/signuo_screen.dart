import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.pinkAccent,
      appBar: AppBar(title:const Text('Nursery Care',
        style: TextStyle(fontSize: 30,color: Colors.white )),
          backgroundColor:Colors.pink ),
      body: const SignUpForm(),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  String _userType = 'user';

  void _signUp() async {
    try {
      var url = Uri.parse('https://clara1-a019a-default-rtdb.firebaseio.com/users.json');

      // Check if the 'users' table exists, and create it if not
      var checkTableResponse = await http.get(url);
      if (checkTableResponse.statusCode != 200) {
        await http.put(url, headers: {'Content-Type': 'application/json'});
      }

      // Now, add the user to the 'users' table
      url = Uri.parse('https://clara1-a019a-default-rtdb.firebaseio.com/users/${_usernameController.text}.json');

      var response = await http.put(
        url,
        body: jsonEncode({
          'username': _usernameController.text,
          'phone': _phoneController.text,
          'password': _passwordController.text,
          'userType': _userType,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        print('Failed to add user. Server returned ${response.statusCode}');
      }
    } catch (e) {
      print('Error during signup and HTTP request: $e');
      // Handle error (show error message, etc.)
    }
  }

  void _goToLogin() {
    Navigator.pushNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(left: 16.0, right: 8.0, top: 12.0, bottom: 4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sign Up',
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),

            Image.network(
              'https://th.bing.com/th/id/R.bf1e29f974a04ce789e42b0017048eb8?rik=ppfB1wOzaFXgVw&riu=http%3a%2f%2fwww.chrichmond.org%2fmedia%2fImage%2fNICU_170523_273_aj_ar_HIPAA_4x6.jpg&ehk=t3x%2b7GqaqT5k0GjLYfY%2bCU1wwSfeGeQ9ROhqqslXQUU%3d&risl=&pid=ImgRaw&r=0',
              width: 120.0,
              height: 120.0,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                labelStyle: TextStyle(color: Colors.white, fontSize: 16),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
              ),
              style: TextStyle(color: Colors.white),
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone',
                labelStyle: TextStyle(color: Colors.white, fontSize: 16),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
              ),
              style: TextStyle(color: Colors.white),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.white, fontSize: 16),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
              ),
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('User Type: ', style: TextStyle(color: Colors.white)),
                Radio(
                  value: 'user',
                  groupValue: _userType,
                  onChanged: (value) => setState(() => _userType = value as String),
                  activeColor: Colors.white,
                ),
                const Text('User', style: TextStyle(color: Colors.white)),
                Radio(
                  value: 'admin',
                  groupValue: _userType,
                  onChanged: (value) => setState(() => _userType = value as String),
                  activeColor: Colors.white,
                ),
                const Text('Admin', style: TextStyle(color: Colors.white)),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _signUp,
              child: const Text('Sign Up', style: TextStyle(fontSize: 20, color: Colors.pink)),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                elevation: MaterialStateProperty.all(4.0),
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: _goToLogin,
              child: const Text('Already have an account? Login', style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
