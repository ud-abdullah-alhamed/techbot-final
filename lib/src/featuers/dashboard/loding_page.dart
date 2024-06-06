import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:techbot/src/config/theme/theme.dart';
import 'package:techbot/src/core/widget/text/text.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Gap(50),
        TextApp.mainAppText(
            "Please wait while we process your request. Your admin approval is pending."),
        const Gap(30),
        LoadingAnimationWidget.inkDrop(
          size: 200,
          color: AppColor.buttonColor,
        ),
      ],
    );
  }
}