// ignore_for_file: avoid_unnecessary_containers

import 'dart:async';

import 'package:chit_chat/screens/main_page.dart';
import 'package:chit_chat/service/auth_service.dart';
import 'package:chit_chat/service/databse_service.dart';
import 'package:chit_chat/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({Key? key}) : super(key: key);

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool isEmailVerified = false;
  AuthService authService = AuthService();
  Timer? timer;
  bool canResentEmail = false;

  @override
  void initState() {
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendEmailVerification();

      Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future sendEmailVerification() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() {
        canResentEmail = false;
      });
      await Future.delayed(const Duration(seconds: 5));
      setState(() {
        canResentEmail = true;
      });
    } catch (e) {
      showSnackBar(context, Colors.red, e.toString());
    }
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    if (mounted) {
      setState(() {
        isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      });
    }

    if (isEmailVerified) timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return isEmailVerified
        ? const MainPage()
        : Scaffold(
            body: Center(
              child: Stack(
                children: [
                  Positioned(
                    child: Container(
                      height: size.height,
                      width: size.width,
                      // color: Colors.black,
                    ),
                  ),
                  Positioned(
                    left: size.width * 0.16,
                    top: size.height * 0.25,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      height: size.height * 0.5,
                      width: size.width * 0.7,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'To confirm your email address,\n tap the link in the mail we sent to you.',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.yellow,
                              onPrimary: Colors.blue,
                            ),
                            onPressed: () {
                              canResentEmail ? sendEmailVerification() : null;
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.mail),
                                SizedBox(width: 10),
                                Text('Resent Email')
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.yellow,
                              onPrimary: Colors.blue,
                            ),
                            onPressed: () {
                              authService.signOut();
                            },
                            child: const Text('Cancel'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: size.width * 0.4,
                    top: size.height * 0.2,
                    child: Container(
                      child: Image.asset(
                        'images/mail.png',
                        height: 80,
                        width: 80,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
