import 'package:alan_voice/alan_voice.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VoicePage extends StatefulWidget {
  const VoicePage({
    super.key,
  });

  @override
  State<VoicePage> createState() => _VoicePageState();
}

class _VoicePageState extends State<VoicePage> {
  RxBool isAlanButtonVisible = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
            AlanVoice.removeButton();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color.fromARGB(255, 11, 10, 61),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 200, child: Image.asset("assets/chatbot.png")),

          const Text(
            "Get comfortable and explore the\n depths of Information Technology with just a click. Ask me anything, and I'll provide the answers you seek!",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color.fromARGB(255, 11, 10, 61),
                fontSize: 20,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 30,
          ),
          //alan voice button
          GestureDetector(
            onTap: () {
              isAlanButtonVisible.value = !isAlanButtonVisible.value;
              if (isAlanButtonVisible.value) {
                AlanVoice.addButton(
                    "9f0357f783eb32172474d97370d6736e2e956eca572e1d8b807a3e2338fdd0dc/stage",
                    buttonAlign: AlanVoice.BUTTON_ALIGN_RIGHT);
              } else {
                AlanVoice.removeButton();
              }
            },
            child: Container(
              width: 300,
              height: 60,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 11, 10, 61),
                  borderRadius: BorderRadius.circular(10)),
              child: Obx(
                () => Center(
                  child: Text(
                    isAlanButtonVisible.value == false ? "Ask" : "Cancel",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
