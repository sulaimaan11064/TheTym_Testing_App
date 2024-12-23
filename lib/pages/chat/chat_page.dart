import 'dart:io';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
final String user;
  final String image;

  // Constructor to accept user and image as parameters
  const ChatPage({super.key, required this.user, required this.image});
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  WebSocket? _webSocket;
  final List<Map<String, String>> _messages = [];
  bool _isConnecting = true;

  @override
  void initState() {
    super.initState();
    _connectWebSocket();
  }

  Future<void> _connectWebSocket() async {
    try {
      _webSocket = await WebSocket.connect('ws://10.0.2.2:8080');
      _isConnecting = false;
      setState(() {});

      _webSocket?.listen((message) {
        setState(() {
          _messages.add({"sender": "other", "text": message});
        });
        _scrollToBottom(); // Auto-scroll to the latest message
      }, onDone: () {
        print('WebSocket closed.');
        _webSocket = null;
      }, onError: (error) {
        print('WebSocket error: $error');
        _webSocket = null;
      });
    } catch (error) {
      print('Error connecting to WebSocket: $error');
      _isConnecting = false;
      setState(() {});
    }
  }

  void _sendMessage() {
    if (_webSocket != null && _controller.text.isNotEmpty) {
      _webSocket?.add(_controller.text);
      setState(() {
        _messages.add({"sender": "me", "text": _controller.text});
      });
      _controller.clear();
      _scrollToBottom(); // Auto-scroll to the latest message
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _webSocket?.close();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(widget.image), // Display user profile image
              radius: 20,
            ),
            SizedBox(width: 10),
            Text(widget.user), // Display user name
          ],
        ),
      ),
     
      body: _isConnecting
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      bool isMe = message["sender"] == "me";

                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue[200] : Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            message["text"]!,
                            style: TextStyle(
                              color: isMe ? Colors.black : Colors.black87,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            labelText: 'Enter a message',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: _sendMessage,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
