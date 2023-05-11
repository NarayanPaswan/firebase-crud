import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  final String username;
  final String userid;
  const HomeView({super.key, required this.username, required this.userid, });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: Column(
        children:  [
           const Text("Home Page"),
            Text(username),
            Text(userid),
        ],
      ),
    );
  }
}