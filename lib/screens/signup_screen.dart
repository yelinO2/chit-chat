import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chit_chat/constants/text.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _auth = FirebaseAuth.instance;

  bool hidePassword = true;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  void signUp() {
    Navigator.pushNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
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
                'images/chat.png',
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
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(),
                    const Center(
                      child: ModifiedText(
                        text: "Let's Get Started",
                        size: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    const Center(
                      child: ModifiedText(
                        text: "Chit-Chat with your friends",
                        size: 15,
                      ),
                    ),
                    const Spacer(),
                    TextFormField(
                      controller: email,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        labelText: 'Enter your email address',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const Spacer(),
                    TextFormField(
                      controller: password,
                      obscureText: hidePassword,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.password),
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
                          ),
                        ),
                        labelText: 'password',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.black,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () async {
                        print('pressed>>>>>>');
                        print('-----------');
                        print(email.text);
                        print('===========');
                        print(password.text);
                        try {
                          final newUser =
                              await _auth.createUserWithEmailAndPassword(
                            email: email.text,
                            password: password.text,
                          );

                          debugPrint('>>>>>>>>>>>');
                          debugPrint(newUser.toString());
                          signUp();
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            print('The password provided is too weak.');
                          } else if (e.code == 'email-already-in-use') {
                            print('The account already exists for that email.');
                          } else if (e.code == 'invalid-email') {
                            print('Please enter a valid email');
                          } else if (e.code == 'empty') {
                            print('Field cannot be empty');
                          }
                        } catch (e) {
                          print('------>>>>>-------');
                        }
                      },
                      child: const Text('Sign up'),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.black,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () {},
                      child: const Text('Sign up with Google'),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const ModifiedText(text: 'Already in Chit-Chat?'),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          style: TextButton.styleFrom(
                            splashFactory: NoSplash.splashFactory,
                          ),
                          child: const ModifiedText(
                            text: 'Sign in here.',
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
