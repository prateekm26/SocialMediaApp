import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveHelper {
  static var initialized = false;

  static open() async {
    if (!initialized) {
      initialized = true;
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String dbFilePath = [appDocDir.path, 'social_media_database'].join('/');
      Hive.init(dbFilePath);

      /// For every model that needs to be saved locally, an adapter is generated
      /// These adapters need to be registered
      //Hive.registerAdapter(UserAdapter());
    }
  }

  close() {
    Hive.close();
  }
}

class Boxes {
  static const String userBox = 'userBox';
  static const String user = 'user';
  static const String userId = 'userId';
  static const String loggedIn = 'logged_in';
  static const String accessToken = 'access_token';
}



class HiveTypes {
  static const int user = 0;
}
