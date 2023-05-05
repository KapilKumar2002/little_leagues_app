import 'package:flutter/material.dart';
import 'package:little_leagues/screens/chat_bot.dart';
import 'package:little_leagues/screens/messages.dart';
import 'package:little_leagues/utils/constants.dart';

class GroupTile extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;
  const GroupTile({
    Key? key,
    required this.groupId,
    required this.groupName,
    required this.userName,
  }) : super(key: key);

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NextScreen(
            context,
            MessagePage(
              groupId: widget.groupId,
              groupName: widget.groupName,
              userName: widget.userName,
              token: "admin",
            ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              widget.groupName.substring(0, 1).toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
          title: Text(
            widget.groupName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "",
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ),
    );
  }
}
