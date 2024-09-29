import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService{
  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();
  Future<void> intiNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid = const AndroidInitializationSettings('defaultIcon');
    var initalizationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (int userId, String? title, String? body, String? payload) async{}
    );
    var initalizationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initalizationSettingsIOS
    );
    await notificationsPlugin.initialize(initalizationSettings, onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async{});
  }
  notificationDetails(){
    return const NotificationDetails(
      android: AndroidNotificationDetails('channelId', 'channelName', importance: Importance.max),
      iOS: DarwinNotificationDetails()
    );
  }
  Future showNotification(
      {int userId = 0, String? title, String? body, String? payload}) async{
    return notificationsPlugin.show(userId, title, body, await notificationDetails());
}
}