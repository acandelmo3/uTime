import 'package:flutter/material.dart';
import 'package:uTime/services/auth.dart';
import 'package:uTime/services/firestore.dart';
import 'ui_login_matrix.dart';
import 'ui_home.dart';

class UIRegister extends StatefulWidget {
  const UIRegister({super.key});

  @override
  State<UIRegister> createState() => _UIRegisterState();
}

class _UIRegisterState extends State<UIRegister> {
  final Auth _auth = Auth();
  final Firestore fs = Firestore();
  final _formkey = GlobalKey<FormState>();

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
      backgroundColor: const Color.fromARGB(255, 79, 118, 176),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 75, 57, 233),
        elevation: 0.0,
        title: const Text('uTime', style: TextStyle(fontFamily: 'roboto')),
        centerTitle: true,
      ),
      body: 
      Stack(children: [
        Container(
            child: Stack(
              children: [
                ClipPath(
                  clipper: WaveClipper(),
                  child: Container(
                    color: const Color.fromARGB(255, 132, 173, 235),
                    height: 300,
                  ),
                ),
                ClipPath(
                  clipper: WaveClipper(),
                  child: Container(
                    color: const Color.fromARGB(255, 190, 220, 255),
                    height: 180,
                  ),
                ),
                
              ],
            ),
          ),
      Container( 
        alignment: Alignment.center,
        child:
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          height: 400,
          width: 200,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20))),
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
                fillColor: Color.fromARGB(255, 241, 244, 255)
              ),
            ),

            const Spacer(flex: 2),
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

            const Spacer(flex: 2),
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

            const Spacer(flex: 2),
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

            const Spacer(flex: 2),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 75, 57, 233),
                  shape: const StadiumBorder()
                ),
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
                      fs.getCurrent();
                      fs.getData(fName, lName, result);
                      Navigator.push(context,
                          //MaterialPageRoute(builder: (context) => HomePage()));
                          MaterialPageRoute(builder: (context) => UIHome()));
                          //MaterialPageRoute(builder: (context) => UIMatrix()));
                    }
                  }
                },
                child: const Text('Register', 
                  style: TextStyle(fontWeight: FontWeight.bold)
                  )
                ),
            const SizedBox(height: 12.0),
            Text(error),
          ]),
        ),
      ),
      )
      )
      ])
    );
  }
}

///Background Designer Function
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    debugPrint(size.width.toString());
    var path = Path();
    path.lineTo(0, size.height / 2);
    var firstStart = Offset(size.width / 5, size.height - 100.0);
    var firstEnd = Offset(size.width / 2.25, size.height - 50.0);
    path.quadraticBezierTo(firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    var secondStart = Offset(size.width - (size.width / 3.24), size.height);
    var secondEnd = Offset(size.width, size.height - 10);

    path.quadraticBezierTo(secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldDelagate) {
    return oldDelagate != this;
  }
}