class MessageData {
  String text;
  String sender;

  MessageData({this.text, this.sender});

  MessageData.fromJson(Map<String, dynamic> parsedJSON)
      : text = parsedJSON['text'],
        sender = parsedJSON['sender'];
}
