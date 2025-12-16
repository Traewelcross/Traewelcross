import 'package:oauth2/oauth2.dart' as oauth2;

abstract class PushApi {
  Future<void> unregisterDevice(oauth2.Client? client);
  Future<bool> registerDevice(oauth2.Client? client);
  Future<String> checkAndSyncToken(String currentSaved, oauth2.Client? client);
  Future<void> initializeNotifications();
}
