import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final dynamic auth;
  const HomePage({
    Key? key,
    required this.auth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('Welcome ' + auth.currentUser!.email + ' to home page'),
          IconButton(
            onPressed: () {
              auth.signOut();
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
    );
  }
}
