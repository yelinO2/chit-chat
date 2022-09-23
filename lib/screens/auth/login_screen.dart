// ignore_for_file: use_build_context_synchronously

import 'package:chit_chat/constants/text.dart';
import 'package:chit_chat/screens/auth/signup_screen.dart';
import 'package:chit_chat/screens/main_page.dart';
import 'package:chit_chat/service/databse_service.dart';
import 'package:chit_chat/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:chit_chat/service/auth_service.dart';

import '../../helper/helper_function.dart';
import '../home_screen.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  AuthService authService = AuthService();
  bool isLoading = false;
  bool hidePassword = true;

  dynamic email;
  dynamic password;

  void login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      await authService.loggedIn(email, password).then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(email);

          await HelperFunction.saveUserLoggedinStatus(true);
          await HelperFunction.saveUserEmail(email);
          await HelperFunction.saveUsername(snapshot.docs[0]['fullName']);
          nextScreenReplace(context, const MainPage());
        } else {
          showSnackBar(context, Colors.red, value);
          setState(() {
            isLoading = false;
          });
        }
      });
    }
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Container(
                  height: size.height,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xff283048),
                        Color(0xff859398),
                      ],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRRect(
                        child: Image.asset(
                          'images/talk.png',
                          height: size.height * 0.3,
                          width: size.width,
                        ),
                      ),
                      Container(
                        height: size.height * 0.7,
                        decoration: const BoxDecoration(
                          color: Color(0xff283048),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              const Spacer(),
                              const ModifiedText(
                                text: 'Welcome back!',
                                size: 25,
                                fontWeight: FontWeight.bold,
                              ),
                              const Spacer(),
                              TextFormField(
                                // controller: email,
                                decoration: textInputDecoration.copyWith(
                                  labelText: 'Please enter your email address',
                                  prefixIcon: Icon(
                                    Icons.mail,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (value) {
                                  setState(() {
                                    email = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "Email can't be empty";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              const Spacer(),
                              TextFormField(
                                // controller: password,
                                obscureText: hidePassword,
                                decoration: textInputDecoration.copyWith(
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        hidePassword = !hidePassword;
                                      });
                                    },
                                    child: Icon(
                                      hidePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_rounded,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  labelText: 'password',
                                ),
                                onChanged: (value) {
                                  password = value;
                                },
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "Password can't be empty";
                                  } else if (value.length < 6) {
                                    return "Password must have 6 characters minimum";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              const Spacer(),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Theme.of(context).primaryColor,
                                  onPrimary: Colors.black,
                                  minimumSize: const Size(double.infinity, 50),
                                ),
                                onPressed: () async {
                                  login();
                                },
                                child: const Text('Log in'),
                              ),
                              const Spacer(),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Theme.of(context).primaryColor,
                                  onPrimary: Colors.black,
                                  minimumSize: const Size(double.infinity, 50),
                                ),
                                onPressed: () {},
                                child: const Text('Continue with Google'),
                              ),
                              const Spacer(),
                              Text.rich(
                                TextSpan(
                                  text: 'New to here?  ',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.blue,
                                        ),
                                        text: 'Creat account',
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            nextScreen(context, const SignUp());
                                          }),
                                  ],
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
