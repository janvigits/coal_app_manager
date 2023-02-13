class chatModel {
  int? chatMessagesId;
  int? messageById;
  String? messageByName;
  String? messageByImage;
  String? messageDate;
  String? message;
  int? isSeen;
  int? isMe;

  chatModel(
      {this.chatMessagesId,
      this.messageById,
      this.messageByName,
      this.messageByImage,
      this.messageDate,
      this.message,
      this.isSeen,
      this.isMe});

  chatModel.fromJson(Map<String, dynamic> json) {
    chatMessagesId = json['chatMessagesId'];
    messageById = json['messageById'];
    messageByName = json['messageByName'];
    messageByImage = json['messageByImage'];
    messageDate = json['messageDate'];
    message = json['message'];
    isSeen = json['isSeen'];
    isMe = json['isMe'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chatMessagesId'] = this.chatMessagesId;
    data['messageById'] = this.messageById;
    data['messageByName'] = this.messageByName;
    data['messageByImage'] = this.messageByImage;
    data['messageDate'] = this.messageDate;
    data['message'] = this.message;
    data['isSeen'] = this.isSeen;
    data['isMe'] = this.isMe;
    return data;
  }
}
