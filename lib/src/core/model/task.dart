class Task {
  late String taskName;
  late String descrition;
  late String startDate;
  late String endDate;
  late String pdfPath;
  late List<String> users;
  late String userEmail;

  Task({
    required this.taskName,
    required this.descrition,
    required this.startDate,
    required this.endDate,
    required this.users,
    required this.userEmail,
    required this.pdfPath,
  });

  // Convert JSON to Task object
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      taskName: json['taskName'] ?? '', // Add null check and default value
      descrition: json['descrition'] ?? '', // Add null check and default value
      startDate: json['startDate'] ?? '', // Add null check and default value
      endDate: json['endDate'] ?? '', // Add null check and default value
      users: (json['users'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(), // Handle List<String> conversion
      userEmail: json['userEmail'] ?? '',
      pdfPath: json['pdfPath'] ?? '', // Add null check and default value
    );
  }

  // Convert Task object to JSON
  Map<String, dynamic> toJson() {
    return {
      "taskName": taskName,
      "descrition": descrition,
      "startDate": startDate,
      "endDate": endDate,
      "users": users,
      "userEmail": userEmail,
      "pdfPath": pdfPath,
    };
  }
}
