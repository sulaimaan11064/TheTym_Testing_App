class ChatUser {
  final String userName;
  final String image;
  String lastMessage;
  String lastMessageTime;
  int unreadCount;

  ChatUser({
    required this.userName,
    required this.image,
    this.lastMessage = "",
    this.lastMessageTime = "",
    this.unreadCount = 0,
  });
}
