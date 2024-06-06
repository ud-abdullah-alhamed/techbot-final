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
      title: 'Reminder App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ReminderForm(),
    );
  }
}

class ReminderForm extends StatefulWidget {
  @override
  _ReminderFormState createState() => _ReminderFormState();
}

class _ReminderFormState extends State<ReminderForm> {
  final _formKey = GlobalKey<FormState>();
  final _reminderNameController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  Future<void> sendPostRequest() async {
    final url = Uri.parse(
        'https://localhost:7012/api/sendEmailForUser'); // Replace with your API endpoint
    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "id": 0,
      "reminderName": _reminderNameController.text,
      "stratDate": _startDateController.text,
      "endDate": _endDateController.text,
      "userEmail": "abood.al7amed@gmail.com"
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Request successful');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Request successful')));
      } else {
        print('Request failed with status: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text('Request failed with status: ${response.statusCode}')));
      }
    } catch (e) {
      print('Request failed with error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Request failed with error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminder Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _reminderNameController,
                decoration: InputDecoration(labelText: 'Reminder Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a reminder name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _startDateController,
                decoration: InputDecoration(labelText: 'Start Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a start date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _endDateController,
                decoration: InputDecoration(labelText: 'End Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an end date';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    sendPostRequest();
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _reminderNameController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }
}
