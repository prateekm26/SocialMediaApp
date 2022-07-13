class UserModel {
  String? emailAddress;
  String? password;
  List<String>? friendList;
  List<String>? receiveRequest;
  List<String>? sentRequest;
  String? userId;
  String? username;
  String? deviceToken;
  String? profileImage;

  UserModel(
      {this.emailAddress,
        this.password,
        this.friendList,
        this.receiveRequest,
        this.sentRequest,
        this.userId,
        this.username,
        this.deviceToken,
      this.profileImage,
      });

  UserModel.fromJson(Map<String, dynamic> json) {
    emailAddress = json['emailAddress'];
    password = json['password'];
    friendList = json['friendList'].cast<String>();
    receiveRequest = json['receiveRequest'].cast<String>();
    sentRequest = json['sentRequest'].cast<String>();
    userId = json['userId'];
    username = json['username'];
    deviceToken = json['deviceToken'];
    profileImage = json['profileImage'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['emailAddress'] = emailAddress;
    data['password'] = password;
    data['friendList'] = friendList;
    data['receiveRequest'] = receiveRequest;
    data['sentRequest'] = sentRequest;
    data['userId'] = userId;
    data['username'] = username;
    data['deviceToken'] = deviceToken;
    data['profileImage'] = profileImage;

    return data;
  }
}
