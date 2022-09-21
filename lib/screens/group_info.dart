import 'package:flutter/material.dart';

class GroupInfoScreen extends StatefulWidget {
  final String groupName;
  final String groupID;
  final String adminName;
  const GroupInfoScreen(
      {Key? key,
      required this.adminName,
      required this.groupID,
      required this.groupName})
      : super(key: key);

  @override
  State<GroupInfoScreen> createState() => _GroupInfoScreenState();
}

class _GroupInfoScreenState extends State<GroupInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(widget.adminName)),
    );
  }
}
