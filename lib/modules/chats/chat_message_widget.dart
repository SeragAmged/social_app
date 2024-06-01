import 'package:flutter/material.dart';

class ChatMessageWidget extends StatelessWidget {
  const ChatMessageWidget(
      {super.key,
      required this.message,
      required this.date,
      required this.mine});
  final String message;
  final String date;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: mine
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.5),
        child: Container(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            color: mine ? Colors.blue.withOpacity(.2) : Colors.grey.shade300,
            borderRadius: BorderRadiusDirectional.only(
              bottomEnd: const Radius.circular(10),
              bottomStart: const Radius.circular(10),
              topStart: mine ? const Radius.circular(10) : Radius.zero,
              topEnd: mine ? Radius.zero : const Radius.circular(10),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5.0,
              horizontal: 10.0,
            ),
            child: Text(
              message,
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
        ),
      ),
    );
  }
}
