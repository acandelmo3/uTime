import 'package:flutter/material.dart';
import 'package:sav3/services/firestore.dart';
import 'package:sav3/screens/user_profile.dart';

class AddFriends extends StatelessWidget {
  AddFriends({super.key});
  final Firestore fs = Firestore();

  @override
  Widget build(BuildContext context) {
    final _controller = TextEditingController();
    int code = -1;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0.0,
        title: const Text('Add Friends'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: _controller,
                obscureText: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'First and Last Name',
                ),
              ),
              ElevatedButton(
                  child: const Text('Search'),
                  onPressed: () => fs.searchUsers(_controller.text).then(
                        (int result) {
                          print(result);
                          code = result;
                          if (result == -1) {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                content: const Text(
                                    'Please enter a First and Last Name'),
                              ),
                            );
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        UserProfile(code, _controller.text)));
                          }
                        },
                      )),
            ]),
      ),
    );
  }
}
