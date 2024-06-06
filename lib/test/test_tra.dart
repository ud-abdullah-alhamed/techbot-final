import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter POST Request Example'),
        ),
        body: Center(
          child: PostRequestWidget(),
        ),
      ),
    );
  }
}

class PostRequestWidget extends StatelessWidget {
  final String url =
      'https://localhost:7012/api/sendEmailForUser'; // Replace with your API endpoint

  Future<void> sendPostRequest() async {
    final Map<String, dynamic> data = {
      "id": 0,
      "reminderName": "sameer reminder",
      "stratDate": "10/06/2024",
      "endDate": "10/05/2024",
      "userEmail": "shanababz2002@gmail.com"
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      print('Request successful');
      print('Response body: ${response.body}');
    } else {
      print('Request failed with status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: sendPostRequest,
      child: Text('Send POST Request'),
    );
  }
}
