// ignore_for_file: must_be_immutable

import 'package:chit_chat/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../screens/chat_screen.dart';
import '../service/databse_service.dart';

class GroupTile extends StatefulWidget {
  String userName;
  String groupId;
  String groupName;
  String? recentMessage;
  GroupTile(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.userName,
      this.recentMessage})
      : super(key: key);

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  dynamic recentMessage;

  @override
  void initState() {
    if (mounted) {
      getRecentMessage();
      super.initState();
    }
  }

  getRecentMessage() async {
    await DatabaseService().getRecentMessage(widget.groupId).then((value) {
      if (mounted) {
        setState(() {
          recentMessage = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextScreen(
            context,
            ChatScreen(
              groupName: widget.groupName,
              groupId: widget.groupId,
              userName: widget.userName,
            ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              textAlign: TextAlign.center,
              widget.groupName.substring(0, 1).toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          title: Text(
            widget.groupName,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
          subtitle: recentMessage == null || recentMessage == ''
              ? Text(
                  '${widget.userName} join the group',
                  style: const TextStyle(color: Colors.white),
                )
              : Text(
                  '$recentMessage',
                  style: const TextStyle(color: Colors.white),
                ),
        ),
      ),
    );
  }
}
