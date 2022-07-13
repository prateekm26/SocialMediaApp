class CallReceiveModel {
  List<Call>? call;

  CallReceiveModel({this.call});

  CallReceiveModel.fromJson(Map<String, dynamic> json) {
    if (json['call'] != null) {
      call = <Call>[];
      json['call'].forEach((v) {
        call!.add(Call.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.call != null) {
      data['call'] = this.call!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Call {
  String? receiverId;
  String? senderId;
  String? senderName;
  String? channel;
  String? token;

  Call({this.receiverId, this.senderId,this.senderName, this.channel, this.token});

  Call.fromJson(Map<String, dynamic> json) {
    receiverId = json['receiverId'];
    senderId = json['senderId'];
    senderName = json['senderName'];
    channel = json['channel'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['receiverId'] = this.receiverId;
    data['senderId'] = this.senderId;
    data['senderName'] = this.senderName;
    data['channel'] = this.channel;
    data['token'] = this.token;
    return data;
  }
}
