import 'package:chit_chat/screens/home_screen.dart';
import 'package:chit_chat/screens/auth/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final _auth = FirebaseAuth.instance;
  bool isLogin = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  getUserInfo() {
    print('>>>>>>>>>');
    if (_auth.currentUser != null) {
      isLogin = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLogin ?  HomeScreen() : const SignUp();
    // return Scaffold(
    //   appBar: AppBar(title: const Text('wlcome')),
    //   body: Center(
    //     child: Column(
    //       children: [
    //         ElevatedButton(
    //           onPressed: () {
    //             Navigator.pushNamed(context, '/home');
    //           },
    //           child: const Text('login'),
    //         ),
    //         ElevatedButton(
    //           onPressed: () {
    //             Navigator.pushNamed(context, '/signup');
    //           },
    //           child: const Text('signup'),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
