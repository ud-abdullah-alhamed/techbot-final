
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:techbot/src/config/theme/theme.dart';
import 'package:techbot/src/core/backend/task_backend/task_repository.dart';
import 'package:techbot/src/featuers/schulde/view/schulde_page.dart';

import '../../../core/model/task.dart';

class TaskController extends GetxController {
  TextEditingController taskNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController pdfPathController = TextEditingController();
  List<String> names = [];
  final TaskRepository _taskRepository = TaskRepository.instance;
  final addFormKey = GlobalKey<FormState>();
  RxList<Task> userTasks = <Task>[].obs;

  clear() {
    taskNameController.clear();
    descriptionController.clear();
    startDateController.clear();
    endDateController.clear();
    pdfPathController.clear();
    names.clear();
  }

  validateDescription(String? description) {
    if (description!.isNotEmpty) {
      return null;
    }
    return 'Description is not valid';
  }

  void createTask(Task task) {
    _taskRepository.createTask(task);
    userTasks.add(task);
  }

  void updateTask(Task task) {
    _taskRepository.updateTask(task);
  }

  Future<void> fetchUserTasks(String userEmail) async {
    final tasks = await _taskRepository.getUserTasks(userEmail);
    userTasks.value = tasks;
  }

  validateService(String? userName) {
    if (GetUtils.isUsername(userName!)) {
      return null;
    }
    return 'UserName is not valid';
  }

  validateField(dynamic text) {
    if (GetUtils.isBlank(text!)!) {
      return null;
    }
    return 'Field is not valid';
  }

  notEmpty(controller) {
    return controller?.text != null && controller.text.isNotEmpty;
  }

  
 Future<void> fetchUserTaskssForDate(
      String userEmail, String selectedDate) async {
    final reminders = await _taskRepository.getUserTasksForDate(
        userEmail, selectedDate);
    userTasks.value = reminders;
  }

  onAdd(Task task) {
    if (addFormKey.currentState!.validate()) {
      createTask(task);
    Get.off(SchuldePage(userEmail: task.userEmail));
      Get.snackbar(
        "Success",
        "Added successfully",
        snackPosition: SnackPosition.BOTTOM,
        colorText: AppColor.mainAppColor,
        backgroundColor: AppColor.success,
      );
      clear();
    } else if (names.isEmpty ) {
      Get.snackbar(
        "ERROR",
        "Please provide a the list of parter",
        snackPosition: SnackPosition.BOTTOM,
        colorText: AppColor.mainAppColor,
        backgroundColor: AppColor.error,
      );
    } else {
      Get.snackbar(
        "ERROR",
        "Invalid form",
        snackPosition: SnackPosition.BOTTOM,
        colorText: AppColor.mainAppColor,
        backgroundColor: AppColor.error,
      );
    }
  }

  @override
  void onClose() {
    // Close resources here if necessary
    super.onClose();
  }
}
