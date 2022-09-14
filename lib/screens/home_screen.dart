import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chit Chat')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {},
          child: const Icon(Icons.chat_bubble_outline),
        ),
      ),
    );
  }
}
