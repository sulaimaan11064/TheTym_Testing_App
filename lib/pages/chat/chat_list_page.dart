import 'package:flutter/material.dart';

import 'chat_page.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
 // Sample data for recent chats with user images
  final List<Map<String, String>> chats = [
    {
      "user": "User1",
      "lastMessage": "Hey, how are you?",
      "time": "10:30 AM",
      "image": "assets/images/profile_img.jpg" // URL for user profile image
    },
    {
      "user": "User2",
      "lastMessage": "Let's meet up soon!",
      "time": "Yesterday",
      "image": "assets/images/profile_img1.jpg" // URL for user profile image
    },
    {
      "user": "User3",
      "lastMessage": "Good morning!",
      "time": "12:00 PM",
      "image": "assets/images/profile_img2.jpg" // URL for user profile image
    },
    // Add more sample chats or fetch this data from your backend
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Search functionality can be added here
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(chat["image"]!),
              radius: 25, // Adjust the size as needed
            ),
            title: Text(chat["user"]!),
            subtitle: Text(chat["lastMessage"]!),
            trailing: Text(chat["time"]!),
            onTap: () {
              // Navigate to the ChatPage when a user is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(user: chat["user"]!, image: chat["image"]!,),
                ),
              );
            },
          );
        },
      ),
    );
  }
}