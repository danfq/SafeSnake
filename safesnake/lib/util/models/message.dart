///Chat Message
class Message {
  //Fields
  final String id;
  final String chatID;
  final String content;
  final int sentAt;
  final int deliveredAt;
  final bool read;
  final String sender;
  final String? replyTo;

  //Chat Message
  const Message({
    required this.id,
    required this.chatID,
    required this.content,
    required this.sentAt,
    required this.deliveredAt,
    required this.read,
    required this.sender,
    this.replyTo,
  });

  ///`Message` to JSON Object
  Map<String, dynamic> toJSON() {
    return {
      "id": id,
      "chat": chatID,
      "content": content,
      "sent_at": sentAt,
      "delivered_at": deliveredAt,
      "read": read,
      "sender": sender,
      "reply_to": replyTo,
    };
  }

  ///JSON Object to `Message`
  factory Message.fromJSON(Map<String, dynamic> json) {
    return Message(
      id: json["id"],
      chatID: json["chat"],
      content: json["decrypted_content"],
      sentAt: json["sent_at"],
      deliveredAt: json["delivered_at"],
      read: json["read"],
      sender: json["sender"],
      replyTo: json["reply_to"],
    );
  }
}
