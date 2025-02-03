import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:zybratask/models/task.dart';


/// All the (crud) option method for hive db
class HiveDataStore{
  /// Box Name - String
  static const boxName ='taskBox';

  /// oour current box will all the saved data inside - Box<Task>
  final Box<Task> box = Hive.box<Task>(boxName);

  /// Add New Task to box
 Future<void> addTask ({required Task task}) async {
   await box.put(task.id, task);
 }
 /// show Task
 Future<Task?> getTask({required String id}) async {
   return box.get(id);
 }

 /// update task
 Future<void> updateTask({required Task task}) async{
   await task.save();
 }

 /// delete task
 Future<void> deleteTask ({required Task task}) async{
   await task.delete();
 }

   /// Listen to box changes
  /// using this method we will listen to box changes and update the
  /// ui accordingly
 ValueListenable<Box<Task>> listentoTask() => box.listenable();

}