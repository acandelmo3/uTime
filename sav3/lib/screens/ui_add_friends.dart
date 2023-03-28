import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:uTime/services/firestore.dart';
import 'ui_user_profile.dart';

class UIAddFriends extends StatelessWidget {
  UIAddFriends({super.key});
  final Firestore fs = Firestore();

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    Logger logger = Logger();

    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 79, 118, 176),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 75, 57, 233),
          elevation: 0.0,
          title: const Text('uTime', style: TextStyle(fontFamily: 'roboto')),
          centerTitle: true,
        ),
        body: Stack(children: [
          Stack(
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
          Container(
            alignment: Alignment.center,
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  height: 150,
                  width: 400,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: controller,
                          obscureText: false,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'First and Last Name',
                          ),
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 75, 57, 233),
                                shape: const StadiumBorder()),
                            child: const Text('Search'),
                            onPressed: () =>
                                fs.searchUsers(controller.text).then(
                                  (int result) {
                                    logger.d(result);
                                    if (result == -1) {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => const AlertDialog(
                                          content: Text(
                                            'Please enter a First and Last Name',
                                          ),
                                        ),
                                      );
                                    } else {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  UIUserProfile(
                                                      controller.text)));
                                    }
                                  },
                                )),
                      ]),
                )),
          )
        ]));
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
    path.quadraticBezierTo(
        firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    var secondStart = Offset(size.width - (size.width / 3.24), size.height);
    var secondEnd = Offset(size.width, size.height - 10);

    path.quadraticBezierTo(
        secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldDelagate) {
    return oldDelagate != this;
  }
}
