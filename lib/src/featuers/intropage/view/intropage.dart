import 'package:flutter/material.dart';
import 'package:techbot/src/config/theme/theme.dart';
import 'package:techbot/src/core/widget/text/text.dart';
import 'package:techbot/src/featuers/buttonspage/view/buttons_page.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.mainAppColor,
        body: GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ButtonsPage()),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  const SizedBox(width: 75),
                  TextApp.splashAppText('TechBot'),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
