// ignore_for_file: sized_box_for_whitespace

import 'package:chit_chat/screens/home_screen.dart';
import 'package:chit_chat/screens/profile_screen.dart';
import 'package:chit_chat/screens/search_screen.dart';
import 'package:chit_chat/screens/settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../helper/helper_function.dart';
import '../service/auth_service.dart';
import '../service/databse_service.dart';
import '../widgets/widgets.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String userName = '';
  String email = '';
  String groupName = '';
  AuthService authService = AuthService();
  Stream? groups;
  bool isLoading = false;
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const HomeScreen();
  final List<Widget> screens = [
    const HomeScreen(),
    const SearchScreen(),
    const Settings(),
    ProfileScreen(),
  ];
  int currentTab = 0;

  @override
  void initState() {
    if (mounted) {
      gettingUserData();
      super.initState();
    }
  }

  gettingUserData() async {
    await HelperFunction.getUserName().then((value) {
      setState(() {
        userName = value!;
      });
    });
    await HelperFunction.getUserEmail().then((value) {
      setState(() {
        email = value!;
      });
    });

    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpened = MediaQuery.of(context).viewInsets.bottom != 0.0;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),
      floatingActionButton: keyboardIsOpened
          ? null
          : FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () {
                popUpDialog(context);
              },
              child: const Icon(
                Icons.add,
                size: 30,
                color: Colors.white,
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: size.height * 0.07,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  MaterialButton(
                    splashColor: Colors.transparent,
                    minWidth: size.width * 0.06,
                    onPressed: () {
                      setState(() {
                        currentScreen = const HomeScreen();
                        currentTab = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          currentTab == 0
                              ? Icons.chat_bubble_outlined
                              : Icons.chat_bubble_outline,
                          color: currentTab == 0
                              ? Theme.of(context).primaryColor
                              : Colors.white,
                        ),
                        Text(
                          'Groups',
                          style: TextStyle(
                            color: currentTab == 0
                                ? Theme.of(context).primaryColor
                                : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    splashColor: Colors.transparent,
                    minWidth: size.width * 0.06,
                    onPressed: () {
                      setState(() {
                        currentScreen = const SearchScreen();
                        currentTab = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          currentTab == 1
                              ? Icons.search_rounded
                              : Icons.search,
                          color: currentTab == 1
                              ? Theme.of(context).primaryColor
                              : Colors.white,
                        ),
                        Text(
                          'Search',
                          style: TextStyle(
                            color: currentTab == 1
                                ? Theme.of(context).primaryColor
                                : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  MaterialButton(
                    splashColor: Colors.transparent,
                    minWidth: size.width * 0.06,
                    onPressed: () {
                      setState(() {
                        currentScreen = ProfileScreen(
                          email: email,
                          userName: userName,
                        );
                        currentTab = 2;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          currentTab == 2
                              ? Icons.account_circle
                              : Icons.account_circle_outlined,
                          color: currentTab == 2
                              ? Theme.of(context).primaryColor
                              : Colors.white,
                        ),
                        Text(
                          'Profile',
                          style: TextStyle(
                            color: currentTab == 2
                                ? Theme.of(context).primaryColor
                                : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    splashColor: Colors.transparent,
                    minWidth: size.width * 0.06,
                    onPressed: () {
                      setState(() {
                        currentScreen = const Settings();
                        currentTab = 3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          currentTab == 3 ? Icons.settings : Icons.settings,
                          color: currentTab == 3
                              ? Theme.of(context).primaryColor
                              : Colors.white,
                        ),
                        Text(
                          'Settings',
                          style: TextStyle(
                            color: currentTab == 3
                                ? Theme.of(context).primaryColor
                                : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text(
                  'Create a Chat-Chat',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    isLoading == true
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor,
                            ),
                          )
                        : TextField(
                            style: const TextStyle(color: Colors.white),
                            onChanged: (value) {
                              setState(() {
                                groupName = value;
                              });
                            },
                            decoration: textfieldDecoration,
                          ),
                  ],
                ),
                actionsPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor),
                    child: const Text('CANCEL'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (groupName != '') {
                        setState(() {
                          isLoading = true;
                        });
                        await DatabaseService(
                                uid: FirebaseAuth.instance.currentUser!.uid)
                            .creatGroup(
                                userName,
                                FirebaseAuth.instance.currentUser!.uid,
                                groupName)
                            .whenComplete(() {
                          isLoading = false;
                          Navigator.of(context).pop();
                          showSnackBar(context, Colors.green,
                              'Group created successfully.');
                        });
                      } else {}
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor),
                    child: const Text('CREATE'),
                  ),
                ],
              );
            },
          );
        });
  }
}
