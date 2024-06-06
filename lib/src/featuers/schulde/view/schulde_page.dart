import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_timeline_calendar/timeline/flutter_timeline_calendar.dart';
import 'package:get/get.dart';
import 'package:techbot/src/config/theme/theme.dart';
import 'package:techbot/src/core/backend/task_backend/task_repository.dart';
import 'package:techbot/src/core/model/task.dart';
import 'package:techbot/src/featuers/schulde/controller/task_controller.dart';
import 'package:techbot/src/featuers/schulde/view/add_task.dart';
import 'package:techbot/test/pdf.dart';

class SchuldePage extends StatefulWidget {
  const SchuldePage({required this.userEmail, super.key});
  final String userEmail;
  @override
  State<SchuldePage> createState() => _SchuldePageState();
}

class _SchuldePageState extends State<SchuldePage> {
  late RxString selectedDate;
  late String datePart;

  @override
  void initState() {
    super.initState();
    selectedDate = (DateTime.now()).toString().obs;
    List<String> parts = selectedDate.value.split(' ');
    datePart = parts[0];
  }

  Future<void> deleteReminder(DocumentSnapshot doc) async {
    try {
      await doc.reference.delete();
      print('Reminder removed successfully');
    } catch (e) {
      print('Error removing reminder: $e');
      throw Exception('Failed to remove reminder');
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.put(TaskRepository());
    Get.put(TaskController());
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.subappcolor,
        onPressed: () {
          Get.to(TaskFormPage(
            userEmail: widget.userEmail,
          ));
        },
        child: Icon(
          Icons.add,
          color: AppColor.mainAppColor,
        ),
      ),
      body: Column(
        children: [
          TimelineCalendar(
            calendarType: CalendarType.GREGORIAN,
            calendarLanguage: "en",
            calendarOptions: CalendarOptions(
              viewType: ViewType.DAILY,
              toggleViewType: true,
              headerMonthElevation: 10,
              headerMonthShadowColor: Colors.black26,
              headerMonthBackColor: Colors.transparent,
            ),
            dayOptions: DayOptions(
                selectedBackgroundColor: AppColor.mainAppColor,
                compactMode: true,
                weekDaySelectedColor: AppColor.mainAppColor,
                disableDaysBeforeNow: true),
            headerOptions: HeaderOptions(
                weekDayStringType: WeekDayStringTypes.SHORT,
                monthStringType: MonthStringTypes.FULL,
                backgroundColor: AppColor.mainAppColor,
                headerTextColor: AppColor.mainAppColor,
                resetDateColor: AppColor.mainAppColor,
                calendarIconColor: AppColor.mainAppColor,
                navigationColor: AppColor.mainAppColor),
            onChangeDateTime: (datetime) {
              setState(() {
                selectedDate.value = datetime.getDate().toString();
                List<String> parts = selectedDate.value.split(' ');
                datePart = parts[0];
                print(datePart);
              });
            },
          ),
          FutureBuilder<void>(
            future: Get.find<TaskController>()
                .fetchUserTaskssForDate(widget.userEmail, datePart),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child:
                        CircularProgressIndicator()); // Display a loading indicator while fetching data
              } else if (snapshot.hasError) {
                return Text(
                    'Error: ${snapshot.error}'); // Display an error message if fetching data fails
              } else {
                // Display the fetched reminders if available
                return Expanded(
                  child: GetBuilder<TaskController>(
                    builder: (controller) {
                      if (controller.userTasks.isEmpty) {
                        return Center(
                          child: Text('No Tasks found for $datePart'),
                        );
                      } else {
                        return ListView.builder(
                          itemCount: controller.userTasks.length,
                          itemBuilder: (context, index) {
                            Task tasks = controller.userTasks[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: ListTile(
                                  title: Text(
                                    tasks.taskName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 8.0),
                                      Text('Start Date: ${tasks.startDate}'),
                                      const SizedBox(height: 4.0),
                                      Text('End Date: ${tasks.endDate}'),
                                    ],
                                  ),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title:
                                              Text(' Name: ${tasks.taskName}'),
                                          content: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                  'description: ${tasks.descrition}'),
                                              const Text('partnters'),
                                              SizedBox(
                                                width: 50,
                                                height: 50,
                                                child: ListView.builder(
                                                    itemCount:
                                                        tasks.users.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Text(
                                                          tasks.users[index]);
                                                    }),
                                              ),
                                              const SizedBox(height: 16),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Get.to(MyPdfViewer(
                                                    pdfUrl: tasks.pdfPath,
                                                  ));
                                                },
                                                child: const Text('View PDF'),
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Close'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
