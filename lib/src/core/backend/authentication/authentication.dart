// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:techbot/src/config/theme/theme.dart';
import 'package:techbot/src/core/backend/exceptions/exceptions.dart';
import 'package:techbot/src/core/backend/user_repository/user_repository.dart';
import 'package:techbot/src/featuers/dashboard/dashboard.dart';
import 'package:techbot/src/featuers/intropage/view/intropage.dart';
import 'package:techbot/src/featuers/mainPage/view/main_page.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;

  final userRepository = Get.put(UserRepository());

  @override
  void onInit() {
    super.onInit();
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    onReady();
  }

  @override
  void onReady() {
    super.onReady();
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    user == null ? Get.offAll(const IntroPage()) : Get.offAll(const UserTypeCheck());
  }

  Future<bool> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return true;
    } on FirebaseException catch (e) {
      print(e.message);
      Get.snackbar("ERROR ", "${e.message}",
          snackPosition: SnackPosition.BOTTOM,
          colorText: AppColor.mainAppColor,
          backgroundColor: AppColor.error);
      return false;
    }
  }

  Future<bool> login(String email, password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      print(LogInWithEmailAndPasswordFailure.code(e.code).message);
      return false;
    }
  }

  Future<void> logout() async => {
        await _auth.signOut(),

        // UserController.instance.clearUserInfo()
      };
}
