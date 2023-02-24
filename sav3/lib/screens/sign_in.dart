import 'package:flutter/material.dart';
import '../services/auth.dart';
import '../services/firestore.dart';
import 'home_page.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final Auth _auth = Auth();
  final _controller1 = TextEditingController();
  final _controller2 = TextEditingController();
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0.0,
        title: const Text('Sign in'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextFormField(
            controller: _controller1,
            obscureText: false,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Email',
            ),
          ),
          TextFormField(
            controller: _controller2,
            obscureText: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Password',
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                email = _controller1.text;
                password = _controller2.text;
                _controller1.clear();
                _controller2.clear();
                dynamic result = await _auth.signIn(email, password);
                if (result != null) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                } else {
                  print('NEED TO WARN USER HERE');
                }
              },
              child: const Text('Submit')),
        ]),
      ),
    );
  }
}
