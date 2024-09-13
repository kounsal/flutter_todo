import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:todotry/bloc/bloc.dart';
import 'package:todotry/bloc/event.dart';
import 'package:todotry/view/tasklist.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todotry/model/taskmodel.dart';

import 'package:timezone/data/latest.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive and register the adapter
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter()); // Register Task adapter

  // Open the tasksBox
  var tasksBox = await Hive.openBox<Task>('tasksBox');
  tz.initializeTimeZones();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_launcher');

  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  await Permission.notification.request();

  runApp(MyApp(tasksBox: tasksBox));
}

class MyApp extends StatelessWidget {
  final Box<Task> tasksBox;

  MyApp({required this.tasksBox});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TaskBloc(tasksBox)..add(LoadTasksEvent()),
      child: MaterialApp(
        title: 'ToDo List',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: TaskListScreen(),
      ),
    );
  }
}
