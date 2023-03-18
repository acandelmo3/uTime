import 'package:flutter/material.dart';
import '../services/auth.dart';
import '../services/firestore.dart';
import 'home_page.dart';
import 'ui_login_matrix.dart';
import 'ui_test_copy.dart';

class UISignIn extends StatefulWidget {
  const UISignIn({super.key});

  @override
  State<UISignIn> createState() => _UISignInState();
}

class _UISignInState extends State<UISignIn> {
  final Auth _auth = Auth();
  final _controller1 = TextEditingController();
  final _controller2 = TextEditingController();
  String email = '';
  String password = '';

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
                    //color: const Color.fromARGB(255, 79, 118, 176),
                    color: const Color.fromARGB(255, 132, 173, 235),
                    height: 300,
                  ),
                ),
                ClipPath(
                  clipper: WaveClipper(),
                  child: Container(
                    //color: const Color.fromARGB(255, 132, 173, 235),
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
          //alignment: Alignment.center,
          height: 220,
          width: 200,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20))),
          padding: const EdgeInsets.all(20.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          //padding: const EdgeInsets.all(20.0)
          TextFormField(
            controller: _controller1,
            obscureText: false,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Email',
            ),
          ),
          const Spacer(flex: 1),
          TextFormField(
            controller: _controller2,
            obscureText: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Password',
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 75, 57, 233),
                  shape: const StadiumBorder()
                ),
              onPressed: () async {
                email = _controller1.text;
                password = _controller2.text;
                _controller1.clear();
                _controller2.clear();
                dynamic result = await _auth.signIn(email, password);
                if (result != null) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UITest()));
                } else {
                  print('NEED TO WARN USER HERE');
                }
              },
              child: const Text('Sign In')),
        ]),
        )
      ),
      )
      ]
      )
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    debugPrint(size.width.toString());
    var path = Path();
    path.lineTo(0, size.height / 2);
    //var firstStart = Offset(size.width / 5, size.height);
    //var firstEnd = Offset(size.width / 2.25, size.height - 50.0);
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