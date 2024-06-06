import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';
import 'package:techbot/firebase_options.dart';
import 'package:techbot/src/config/theme/theme.dart';
import 'package:techbot/src/core/backend/task_backend/task_repository.dart';
import 'package:techbot/src/featuers/intropage/view/intropage.dart';
import 'src/core/backend/authentication/authentication.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) => Get.put(AuthenticationRepository()));
  Get.put(TaskRepository());

  Gemini.init(apiKey: 'AIzaSyDfv5EYlRRB7OVbvvY61kXT98vIo1HQtfM');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TechBot',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColor.subappcolor),
        useMaterial3: true,
      ),
      home: const IntroPage(),
    );
  }
}
