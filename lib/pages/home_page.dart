  import 'package:chat_app/pages/profile_page.dart';
import 'package:chat_app/pages/story_page.dart';
  import 'package:chat_app/services/auth/auth_services.dart';
  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'package:intl/intl.dart';
  import '../services/chat/chat_service.dart';
  import 'chat_page.dart';

  class HomePage extends StatefulWidget {
    const HomePage({Key? key});

    @override
    State<HomePage> createState() => _HomePageState();
  }

  class _HomePageState extends State<HomePage> {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final chatService = ChatService();
    int _selectedIndex = 0;

    void signOut() {
      final authService = Provider.of<AuthService>(context, listen: false);
      authService.signOut();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('ChatApp'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
              icon: const Icon(Icons.account_circle_outlined),
            ),
            IconButton(
              onPressed: signOut,
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: Column(
          children: [
            _buildStoryNavigationBar(),
            Expanded(child: _buildUserList()),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: 'Messages',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.contacts),
              label: 'Contacts',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      );
    }

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    Widget _buildStoryNavigationBar() {
      List<String> stories = ['Story 1', 'Story 2', 'Story 3']; // Add your stories here
      return StoryNavigationBar(stories: stories);
    }


    Widget _buildUserList() {
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error!'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot document = snapshot.data!.docs[index];
              final Map<String, dynamic> data =
              document.data()! as Map<String, dynamic>;
              final currentUserEmail = _auth.currentUser!.email;
              if (currentUserEmail != data['email']) {
                return _buildUserListItem(data);
              } else {
                return const SizedBox();
              }
            },
          );
        },
      );
    }

    Widget _buildUserListItem(Map<String, dynamic> userData) {
      final chatService = ChatService();

      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ChatPage(
                    recieverUserEmail: userData['email'],
                    recieverUserID: userData['uid'],
                  ),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: FutureBuilder<Map<String, dynamic>?>(
            future: chatService.getLastMessage(
              FirebaseAuth.instance.currentUser!.uid,
              userData['uid'],
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ListTile(
                  title: Text(
                    userData['email'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                );
              }
              if (snapshot.hasData && snapshot.data != null) {
                final lastMessage = snapshot.data!;
                final lastSentTime = (lastMessage['timestamp'] as Timestamp)
                    .toDate();
                final timeDifference = DateTime.now().difference(lastSentTime);
                String displayTime;
                if (timeDifference.inDays > 1) {
                  // More than one day ago, display the date
                  displayTime = DateFormat('MMM dd').format(lastSentTime);
                } else if (timeDifference.inDays == 1) {
                  // Yesterday
                  displayTime = 'Yesterday';
                } else {
                  // Less than a day ago, display the time
                  displayTime =
                      DateFormat.jm().format(lastSentTime); // Format as 'hh:mm a'
                }
                return ListTile(
                  title: Text(
                    userData['email'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          lastMessage['message'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        displayTime,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                );
              }
              return ListTile(
                title: Text(
                  userData['email'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
        ),
      );
    }
  }