import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:zybratask/views/home/components/home_app_bar.dart';
import 'package:zybratask/views/home/home_view.dart';
import 'package:zybratask/views/tasks/task_view.dart';

import 'data/hive_data_store.dart';
import 'models/task.dart';

Future<void> main() async {
  /// Init Hive Db before running the app
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  /// Register Hive Adapter
  Hive.registerAdapter(TaskAdapter());

  /// Open a box
  Box<Task> box = await Hive.openBox<Task>(HiveDataStore.boxName);

  /// Delete data from the previous day
  for (var task in box.values) {
    if (task.createdAtTime.day != DateTime.now().day) {
      task.delete();
    }
  }

  runApp(BaseWidget(child: MyApp()));
}

class BaseWidget extends InheritedWidget {
  final HiveDataStore dataStore = HiveDataStore();
  final Widget child;

  BaseWidget({super.key, required this.child}) : super(child: child);

  static BaseWidget of(BuildContext context) {
    final base = context.dependOnInheritedWidgetOfExactType<BaseWidget>();
    if (base != null) {
      return base;
    } else {
      throw StateError('Could not find ancestor widget of type BaseWidget');
    }
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Task Management',
      theme: ThemeData(
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Colors.black,
            fontSize: 45,
            fontWeight: FontWeight.bold,
          ),
          titleMedium: TextStyle(
            color: Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
          displayMedium: TextStyle(
            color: Colors.white,
            fontSize: 21,
          ),
          displaySmall: TextStyle(
            color: Color.fromARGB(255, 234, 234, 234),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          headlineMedium: TextStyle(
            color: Colors.grey,
            fontSize: 17,
          ),
          headlineSmall: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
          titleSmall: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
          titleLarge: TextStyle(
            fontSize: 40,
            color: Colors.black,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      home: HomeView(
        titleTaskController: TextEditingController(),
        descriptionTaskController: TextEditingController(),
        task: null,
      ),
    );
  }
}
