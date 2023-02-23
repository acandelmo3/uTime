import 'package:flutter/material.dart';

import 'add_friends.dart';
import 'friend_requests.dart';

class FriendsList extends StatelessWidget {
  const FriendsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0.0,
        title: const Text('Friends'),),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Add Friends'),
              onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddFriends())),
            ),
            ElevatedButton(
              child: const Text('Friend Requests'),
              onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FriendRequests())),
            ),
          ]),),
    );
  }
}
