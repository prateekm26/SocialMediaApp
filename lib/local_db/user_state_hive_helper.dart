import 'package:hive/hive.dart';

import 'hive_database_helper.dart';

/// Helper class to save user information locally on the device
class UserStateHiveHelper {
  UserStateHiveHelper.__internal();
  static final UserStateHiveHelper _instance = UserStateHiveHelper.__internal();
  static UserStateHiveHelper get instance => _instance;

  Future<Box<dynamic>> _open() async {
    await HiveHelper.open();
    return await Hive.openBox(Boxes.userBox);
  }

  void close() {
    Hive.openBox(Boxes.userBox).then((box) {
      box.close();
    });
  }

  Future<void> logIn() async {
    await _open();
    Hive.box(Boxes.userBox).put(Boxes.loggedIn, true);
  }

  Future<void> logOut() async {
    print("logged out");
    await _open();
    Hive.box(Boxes.userBox).put(Boxes.loggedIn, false);
    deleteUser();
  }

  Future<bool> isLoggedIn() async {
    await _open();
    final loggedIn = Hive.box(Boxes.userBox).get(Boxes.loggedIn);
    return loggedIn ?? false;
  }

  Future<void> deleteUser() async {
    await _open();
    Hive.box(Boxes.userBox).delete(Boxes.user);
    return;
  }

  Future<void> setUserName(String? userName) async {
    await _open();
    Hive.box(Boxes.userBox).put(Boxes.user, userName);
  }

  Future<void> setUserId(String userId) async {
    await _open();
    Hive.box(Boxes.userBox).put(Boxes.userId, userId);
  }

  Future<String> getUserName() async {
    await _open();
    final userName = Hive.box(Boxes.userBox).get(Boxes.user);
    return userName;
  }







  Future<String> getUserId() async {
    await _open();
    final userId = Hive.box(Boxes.userBox).get(Boxes.userId);
    return userId;
  }

  Future<void> setAccessToken(String accessToken) async {
    await _open();
    Hive.box(Boxes.userBox).put(Boxes.accessToken, accessToken);
  }

  Future<String?> getAccessToken() async {
    await _open();
    final accessToken = Hive.box(Boxes.userBox).get(Boxes.accessToken);
    return accessToken ?? "";
  }
}
