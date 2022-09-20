// ignore_for_file: avoid_print

import 'package:chit_chat/helper/helper_function.dart';
import 'package:chit_chat/service/databse_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future registerUser(String userName, String email, String password) async {
    try {
      User? newUser = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;
      print('<<<<<<<<<<<user>>>>>>>>>>>');
      print(newUser);

      if (newUser != null) {
        await DatabaseService(uid: newUser.uid).savingUserData(userName, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future loggedIn(String email, String password) async {
    try {
      User? newUser = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;

      if (newUser != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future signOut() async {
    try {
      await HelperFunction.saveUserLoggedinStatus(false);
      await HelperFunction.saveUserEmail('');
      await HelperFunction.saveUsername('');
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}
