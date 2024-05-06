
import 'package:chat_app/components/chat_bubble.dart';
import 'package:chat_app/components/my_text_field.dart';
import 'package:chat_app/pages/video_call_page.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'call_page.dart';

class ChatPage extends StatefulWidget {
  final String recieverUserEmail;
  final String recieverUserID;

  const ChatPage({
    Key? key,
    required this.recieverUserEmail,
    required this.recieverUserID,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.recieverUserID,
        _messageController.text,
      );
      // Clear the controller after sending the messages
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () {
              // Navigate to a different page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CallPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.video_camera_back_outlined),
            onPressed: () {
              // Navigate to a different page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VideoCallPage()),
              );
            },
          ),
        ],
        title: Text(widget.recieverUserEmail,style: Theme.of(context).textTheme.titleMedium!.apply(color: Colors.blue),),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          // User input
          _buildMessageInput(),
          const SizedBox(height: 25),
        ],
      ),
    );
  }

  // Build message list
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
        widget.recieverUserID,
        _firebaseAuth.currentUser!.uid,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }

        // Group messages by date
        Map<DateTime, List<DocumentSnapshot>> groupedMessages = {};
        snapshot.data!.docs.forEach((document) {
          DateTime date = (document.data() as Map<String, dynamic>)['timestamp'].toDate();
          DateTime formattedDate = DateTime(date.year, date.month, date.day);
          if (!groupedMessages.containsKey(formattedDate)) {
            groupedMessages[formattedDate] = [];
          }
          groupedMessages[formattedDate]!.add(document);
        });

        // Create a list of widgets with date headers
        List<Widget> messageWidgets = [];
        groupedMessages.forEach((date, messages) {
          messageWidgets.add(_buildDateHeader(date));
          messages.forEach((message) {
            messageWidgets.add(_buildMessageItem(message));
          });
        });

        return ListView(
          children: messageWidgets,
        );
      },
    );
  }

  Widget _buildDateHeader(DateTime date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Center(
        child: Text(
          _formatDate(date),
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }


  // Build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // Determine the alignment based on the senderId
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    // Determine the color of the message bubble based on senderId
    var bubbleColor = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Colors.blue // Color for sender
        : Colors.lightGreen; // Color for receiver

    // Determine the color of the text based on senderId
    var textColor = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Colors.white // Text color for sender
        : Colors.black; // Text color for receiver

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: (alignment == Alignment.centerRight)
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            ChatBubble(
              message: data['message'],
              backgroundColor: bubbleColor,
              textColor: textColor,
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(data['timestamp']),
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }


  String _formatTime(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    String formattedTime = '${dateTime.hour}:${dateTime.minute}';
    return formattedTime;
  }


  // Format timestamp into readable date-time format
  String _formatDateTime(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    String formattedDate = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    String formattedTime = '${dateTime.hour}:${dateTime.minute}';
    return '$formattedDate - $formattedTime';
  }

  // Build message input
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          // Text field
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: 'Enter message',
              obsecureText: false,
            ),
          ),

          // Send button
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(
              Icons.send,
              size: 30,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
