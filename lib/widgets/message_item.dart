import 'package:chat_app/colors.dart';
import 'package:flutter/material.dart';

class MessageItem extends StatelessWidget {
  const MessageItem(
      {super.key,
      required this.sentByMe,
      required this.message,
      required this.time});
  final bool sentByMe;
  final String message;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: FittedBox(
        child: Container(
          // height: MediaQuery.of(context).size.height * 0.08,
          // width: MediaQuery.of(context).size.width * 0.1,
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
            color: sentByMe ? kPurple : Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                message,
                style: TextStyle(
                  color: (sentByMe ? Colors.white : kPurple).withOpacity(0.7),
                  fontSize: 18,
                ),
              ),
              const SizedBox(width: 5),
              Text(time,
                  style: TextStyle(
                      color: sentByMe ? Colors.white : Colors.black87)),
            ],
          ),
        ),
      ),
    );
  }
}
