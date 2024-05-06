import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final Color backgroundColor;
  final Color textColor;

  const ChatBubble({Key? key, required this.message, required this.backgroundColor, required this.textColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: backgroundColor,
      ),
      child: SelectableText(
        message,
        style: TextStyle(fontSize: 16,color: textColor),
      ),
    );
  }
}
