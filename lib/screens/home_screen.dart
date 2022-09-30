// ignore_for_file: use_build_context_synchronously, sized_box_for_whitespace
import 'package:chit_chat/constants/text.dart';
import 'package:chit_chat/helper/helper_function.dart';
import 'package:chit_chat/screens/auth/login_screen.dart';
import 'package:chit_chat/screens/profile_screen.dart';
import 'package:chit_chat/screens/search_screen.dart';
import 'package:chit_chat/service/databse_service.dart';
import 'package:chit_chat/widgets/group_tile.dart';
import 'package:chit_chat/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chit_chat/service/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = '';
  String email = '';
  String groupName = '';
  dynamic recentMessage;

  Stream? groups;
  bool isLoading = false;

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

  String getGpID(String res) {
    return res.substring(0, res.indexOf('_'));
  }

  String getGpName(String res) {
    return res.substring(res.indexOf('_') + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: const Text(
          'Chit-Chat',
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: listGroup(),
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
                  'Create a group chat',
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
                            onChanged: (value) {
                              setState(() {
                                groupName = value;
                              });
                            },
                            decoration: textfieldDecoration,
                          ),
                  ],
                ),
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

  listGroup() {
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['group'] != null) {
            if (snapshot.data['group'].length != 0) {
              return ListView.builder(
                  itemCount: snapshot.data['group'].length,
                  itemBuilder: (context, index) {
                    int reverseIndex =
                        snapshot.data['group'].length - index - 1;

                    return GroupTile(
                      groupId: getGpID(snapshot.data['group'][reverseIndex]),
                      groupName:
                          getGpName(snapshot.data['group'][reverseIndex]),
                      userName: snapshot.data['fullName'],
                      recentMessage: recentMessage,
                    );
                  });
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor),
          );
        }
      },
    );
  }

  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              popUpDialog(context);
            },
            child: const Icon(
              Icons.add_circle,
              color: Colors.grey,
              size: 75,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "You've not joined any Chit-Chat, you can tap on the add icon to create a Chat or tap search button to search a chat.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}
