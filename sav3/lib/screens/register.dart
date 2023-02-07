import 'package:dob_input_field/dob_input_field.dart';
import 'package:flutter/material.dart';
import 'package:sav3/auth.dart';
import 'package:sav3/firestore.dart';

import 'home_page.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final Auth _auth = Auth();
  final Firestore fs = Firestore();
  final _formkey = GlobalKey<FormState>();

  //gets input
  final _controller1 = TextEditingController();
  final _controller2 = TextEditingController();
  final _controller3 = TextEditingController();
  final _controller4 = TextEditingController();
  String error = '';
  String email = '';
  String password = '';
  String fName = '';
  String lName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0.0,
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formkey,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            TextFormField(
              validator: (val) => val!.isEmpty ? 'Please Enter Email' : null,
              controller: _controller1,
              obscureText: false,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Email',
              ),
            ),
            Spacer(flex: 2),
            TextFormField(
              validator: (val) => val!.length < 7
                  ? 'Please Enter Password 7+ Chars Long'
                  : null,
              controller: _controller2,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Password',
              ),
            ),
            Spacer(flex: 2),
            TextFormField(
              validator: (val) =>
                  val!.isEmpty ? 'Please Enter First Name' : null,
              controller: _controller3,
              obscureText: false,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'First Name',
              ),
            ),
            Spacer(flex: 2),
            TextFormField(
              validator: (val) =>
                  val!.isEmpty ? 'Please Enter Last Name' : null,
              controller: _controller4,
              obscureText: false,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Last Name',
              ),
            ),
            Spacer(flex: 2),
            ElevatedButton(
                onPressed: () async {
                  email = _controller1.text;
                  password = _controller2.text;
                  fName = _controller3.text;
                  lName = _controller4.text;
                  if (_formkey.currentState!.validate()) {
                    dynamic result = await _auth.register(email, password);
                    if (result == null) {
                      setState(() => error = 'Please Enter a Valid Email');
                    } else {
                      fs.getData(fName, lName);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    }
                  }
                },
                child: const Text('Submit')),
            const SizedBox(height: 12.0),
            Text(error),
          ]),
        ),
      ),
    );
  }
}
