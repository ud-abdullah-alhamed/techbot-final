import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:techbot/firebase_options.dart';
import 'package:techbot/test/email_test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Dropdown',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ReminderForm(),
    );
  }
}

class SelectUser extends StatefulWidget {
  const SelectUser({required this.names, super.key});
  final List<String> names;
  @override
  State<SelectUser> createState() => _SelectUserState();
}

class _SelectUserState extends State<SelectUser> {
  String? selectedCategory;
  List<String> selectedOptions = []; // List to store selected options

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('User').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                List<DocumentSnapshot> categories = snapshot.data!.docs;

                List<String> categoryTitles =
                    categories.map((e) => e['UserName'].toString()).toList();

                return Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 225, 254, 226)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Center(
                    child: DropdownButton(
                      dropdownColor: Colors.grey[200],
                      icon: const Icon(
                        Icons.arrow_drop_down_circle_sharp,
                        color: Colors.black,
                      ),
                      hint: const Text('Select partner'),
                      value: selectedCategory,
                      onChanged: (newValue) {
                        setState(() {
                          if (!selectedOptions.contains(newValue)) {
                            selectedOptions.add(newValue.toString());
                            selectedCategory = newValue as String?;
                            widget.names.add(newValue.toString());

                            print(widget.names);
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Duplicate Selection'),
                                  content: const Text(
                                      'This option has already been added.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        });
                      },
                      items: categoryTitles.map((title) {
                        return DropdownMenuItem(
                          value: title,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              title,
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(), // Remove the underline
                      underline: Container(),
                      isExpanded: true,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Selected parterns: ${selectedOptions.join(", ")}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }
}
