class ChatMessage {
  final String message;
  final String sentByMe;
  final String time;
  const ChatMessage({
    required this.message,
    required this.sentByMe,
    required this.time,
  });
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      message: json['message'],
      sentByMe: json['sentByMe'],
      time: json['time'],
    );
  }
}
