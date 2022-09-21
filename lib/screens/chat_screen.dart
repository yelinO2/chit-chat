import 'package:chit_chat/screens/group_info.dart';
import 'package:chit_chat/service/databse_service.dart';
import 'package:chit_chat/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String groupID;
  final String groupName;
  final String userName;
  const ChatScreen(
      {Key? key,
      required this.groupID,
      required this.groupName,
      required this.userName})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String admin = '';
  Stream<QuerySnapshot>? chats;
  @override
  void initState() {
    getChatandAdmin();
    super.initState();
  }

  getChatandAdmin() {
    DatabaseService().getChats(widget.groupID).then((value) {
      setState(() {
        chats = value;
      });
    });

    DatabaseService().getGroupAdimin(widget.groupID).then((value) {
      setState(() {
        admin = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        elevation: 0,
        title: Text(
          widget.groupName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(
                    context,
                    GroupInfoScreen(
                      adminName: admin,
                      groupID: widget.groupID,
                      groupName: widget.groupName,
                    ));
              },
              icon: const Icon(Icons.info_outline_rounded))
        ],
      ),
    );
  }
}
