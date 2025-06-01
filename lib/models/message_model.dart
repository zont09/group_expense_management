class MessageModel {
  final String content;
  final DateTime date;
  final bool isMe;
  final bool enable;

  MessageModel(
      {required this.content,
      required this.date,
      required this.isMe,
      required this.enable});

  MessageModel copyWith(
          {String? content, DateTime? date, bool? isMe, bool? enable}) =>
      MessageModel(
        content: content ?? this.content,
        date: date ?? this.date,
        isMe: isMe ?? this.isMe,
        enable: enable ?? this.enable,
      );
}
