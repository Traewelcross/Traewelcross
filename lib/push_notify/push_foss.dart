import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:traewelcross/push_notify/push_interface.dart';

Future<void> initUnifiedPush() async {
  return;
}

class PushFoss implements PushApi {
  @override
  Future<String> checkAndSyncToken(String currentSaved, oauth2.Client? client) {
    return Future.value(currentSaved);
  }

  @override
  Future<void> initializeNotifications() {
    return Future.value();
  }

  @override
  Future<bool> registerDevice(oauth2.Client? client) {
    return Future.value(false);
  }

  @override
  Future<void> unregisterDevice(oauth2.Client? client) {
    return Future.value();
  }
}
