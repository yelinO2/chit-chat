import 'package:chit_chat/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;

  final _firestore = FirebaseFirestore.instance;

  TextEditingController msg = TextEditingController();
  List msgList = [];
  User? loginUser;

  void initState() {
    getUser();
    getMsg();
    super.initState();
  }

  void getUser() {
    loginUser = _auth.currentUser;
  }

  void getMsg() async {
    final messages = await _firestore.collection('chit-chat-gp-1').get();
    // msgList = messages;

    for (var message in messages.docs) {
      print('<<<<<message>>>>>>');
      print(message.data()['msg']);
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('Chit Chat')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            authService.signOut();
          },
          child: const Text('sign out'),
        ),
      ),
    );
  }
}
