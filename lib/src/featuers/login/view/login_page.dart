import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:techbot/src/config/theme/theme.dart';
import 'package:techbot/src/core/backend/user_repository/user_repository.dart';
import 'package:techbot/src/core/controller/user_controller.dart';
import 'package:techbot/src/core/model/form_model.dart';
import 'package:techbot/src/core/widget/buttons/buttons.dart';
import 'package:techbot/src/core/widget/froms/form_model.dart';
import 'package:techbot/src/core/widget/text/text.dart';
import 'package:techbot/src/featuers/login/controller/login_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final controller = Get.put(LoginController());

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void clearText() {
    controller.email.clear();
    controller.password.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_back_ios,
                color: AppColor.mainAppColor,
              )),
          title: TextApp.appBarText('login'),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            child: Column(
              children: [
                TextApp.mainAppText('Let’s Login.!'),
                Form(
                  key: controller.formkey,
                  child: SizedBox(
                    height: 450,
                    width: double.infinity,
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 30),
                      children: [
                        FormWidget(
                            textForm: FormModel(
                                controller: controller.email,
                                enableText: false,
                                hintText: "Email",
                                icon: const Icon(Icons.email),
                                invisible: false,
                                validator: (email) =>
                                    controller.validateEmail(email),
                                type: TextInputType.emailAddress,
                                onChange: null,
                                inputFormat: [],
                                onTap: null)),
                        const Gap(15),
                        FormWidget(
                            textForm: FormModel(
                                controller: controller.password,
                                enableText: false,
                                hintText: "Password",
                                icon: const Icon(Icons.password),
                                invisible: true,
                                validator: (password) =>
                                    controller.vaildatePassword(password),
                                type: TextInputType.visiblePassword,
                                onChange: null,
                                inputFormat: [],
                                onTap: null)),
                        const Gap(15),
                        Buttons.formscontainer(
                          title: 'Login',
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: AppColor.buttonColor,
                                        radius: 60,
                                        child: Icon(
                                          Icons.done,
                                          size: 100,
                                          color: AppColor.subappcolor,
                                        ),
                                      ),
                                      const SizedBox(height: 40),
                                      Text(
                                        'Yeay! Welcome Back',
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            color: AppColor.buttonColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Once again you login successfully to the medidoc app',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            color: AppColor.buttonColor,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 40),
                                      ElevatedButton(
                                        onPressed: () {
                                          // Implement navigation to home screen
                                          controller.onLogin();
                                          UserRepository().getUserDetails(
                                              controller.email.text);
                                          UserController().logIn();
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  AppColor.buttonColor),
                                          minimumSize:
                                              MaterialStateProperty.all<Size>(
                                            const Size(183, 70),
                                          ), // Set width and height
                                        ),
                                        child: Text(
                                          'Go to home',
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                              color: AppColor.subappcolor,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              barrierDismissible:
                                  false, // Dialog will not dismiss on tap outside
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(20),
                RichText(
                  text: TextSpan(
                    text: 'dont have have an account? ',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.to(Container());
                          },
                        text: 'Sign Up',
                        style: TextStyle(
                          color: AppColor.mainAppColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
