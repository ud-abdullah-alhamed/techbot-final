import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:techbot/src/config/theme/theme.dart';

import '../../model/task.dart';

class TaskRepository extends GetxController {
  static TaskRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  createTask(Task task) {
    _db
        .collection("Tasks")
        .add(task.toJson())
        .whenComplete(() => Get.snackbar(
              "Success",
              "Task created successfully",
              snackPosition: SnackPosition.BOTTOM,
              colorText: AppColor.subappcolor,
              backgroundColor: AppColor.success,
            ))
        // ignore: body_might_complete_normally_catch_error
        .catchError((error) {
      Get.snackbar(
        "Error",
        "Failed to create task, try again",
        snackPosition: SnackPosition.BOTTOM,
        colorText: AppColor.subappcolor,
        backgroundColor: AppColor.error,
      );
    });
  }

  Future<void> updateTask(Task task) async {
    await _db.collection("Tasks").doc().update(task.toJson());
  }

  Future<Task> getTaskDetails(String taskName) async {
    final snapshot = await _db
        .collection("Tasks")
        .where("taskName", isEqualTo: taskName)
        .get();
    final taskData = snapshot.docs.map((e) => Task.fromJson(e.data())).single;
    return taskData;
  }

  Future<bool> taskExists(String taskName) async {
    try {
      QuerySnapshot taskSnapshot = await _db
          .collection('Tasks')
          .where('taskName', isEqualTo: taskName)
          .get();

      return taskSnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking task existence: $e');
      return false;
    }
  }

  Future<List<Task>> getUserTasks(String userEmail) async {
    List<Task> userTasks = [];

    try {
      QuerySnapshot taskSnapshot = await _db
          .collection('Tasks')
          .where('userEmail', isEqualTo: userEmail)
          .get();

      userTasks = taskSnapshot.docs
          .map((doc) => Task.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting user tasks: $e');
    }

    return userTasks;
  }

  Future<List<Task>> getUserTasksForDate(
      String userEmail, String selectedDate) async {
    try {
      final QuerySnapshot taskSnapshot = await _db
          .collection('Tasks')
          .where('userEmail', isEqualTo: userEmail)
          .where('startDate', isEqualTo: selectedDate)
          .get();

      return taskSnapshot.docs
          .map((doc) => Task.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting user reminders for date: $e');
      return [];
    }
  }
}
