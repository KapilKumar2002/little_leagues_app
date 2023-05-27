import 'package:flutter/material.dart';
import 'package:little_leagues/screens/showImage.dart';
import 'package:little_leagues/utils/constants.dart';
import 'package:intl/intl.dart';

class MessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final bool sentByMe;
  final String type;
  final DateTime time;
  const MessageTile(
      {Key? key,
      required this.message,
      required this.sender,
      required this.sentByMe,
      required this.time,
      required this.type})
      : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: widget.sentByMe ? 0 : 24,
          right: widget.sentByMe ? 24 : 0),
      alignment: widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: widget.sentByMe
            ? const EdgeInsets.only(left: 30, bottom: 2)
            : const EdgeInsets.only(right: 30, bottom: 2),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurStyle: BlurStyle.solid,
                  spreadRadius: 1,
                  blurRadius: 1,
                  color: white2)
            ],
            borderRadius: widget.sentByMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  )
                : const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
            color: widget.sentByMe ? black : Colors.grey[700]),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.sentByMe
                      ? "You".toUpperCase()
                      : widget.sender.toUpperCase(),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: widget.sentByMe ? white2 : white2,
                      letterSpacing: -0.5),
                ),
                const SizedBox(
                  height: 8,
                ),
                widget.type == "text"
                    ? Text(widget.message,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 16,
                            color: widget.sentByMe ? white2 : white2))
                    : InkWell(
                        onTap: () {
                          NextScreen(
                              context,
                              ShowImageScreen(
                                image: widget.message,
                                sender: widget.sentByMe ? "You" : widget.sender,
                                time: DateFormat.Hm()
                                    .format(widget.time)
                                    .toString(),
                              ));
                        },
                        child: Hero(
                          tag: widget.message,
                          child: Image.network(
                            widget.message,
                            width: width(context) / 3.5,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
              ],
            ),
            horizontalSpace(4),
            Text(
              DateFormat.Hm().format(widget.time).toString(),
              style: text8w400(widget.sentByMe ? white2 : white2),
            ),
          ],
        ),
      ),
    );
  }
}
