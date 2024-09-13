import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:todotry/main.dart';
import 'package:todotry/model/taskmodel.dart';
import 'package:timezone/timezone.dart' as tz;

Future<void> scheduleNotification(Task task) async {
  // Request notification permission
  var notificationStatus = await Permission.notification.status;
  if (!notificationStatus.isGranted) {
    await Permission.notification.request();
  }

  // Request exact alarms permission for Android 12+
  var exactAlarmsStatus = await Permission.ignoreBatteryOptimizations.status;
  if (exactAlarmsStatus != PermissionStatus.granted) {
    await Permission.ignoreBatteryOptimizations.request();
  }

  // Create a notification channel for Android
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'task_notifications',
    'Task Notifications',
    channelDescription: 'Notifications for task reminders',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: true,
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.zonedSchedule(
    task.dueDate.hour, // Use a unique ID for the notification
    'Task Reminder',
    'Task: ${task.title} is due soon!',
    tz.TZDateTime.from(task.dueDate, tz.local), // Schedule at due date
    platformChannelSpecifics,
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
  );
}
