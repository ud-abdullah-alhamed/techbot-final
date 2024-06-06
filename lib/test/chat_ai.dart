import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:techbot/src/config/theme/theme.dart';
import 'package:techbot/src/core/backend/authentication/authentication.dart';
import 'package:techbot/src/core/backend/user_repository/user_repository.dart';

class AiChat extends StatefulWidget {
  const AiChat({super.key});

  @override
  State<AiChat> createState() => _AiChatState();
}

class _AiChatState extends State<AiChat> {
  late final Gemini gemini;
  List<ChatMessage> messages = [];
  String geminiResponse = '';

  final _authRepo = Get.put(AuthenticationRepository());
  late final email = _authRepo.firebaseUser.value?.email;
  final userRepository = Get.put(UserRepository());
  @override
  void initState() {
    super.initState();
    userRepository.getUserDetails(email ?? '');
    gemini = Gemini.instance; // Initialize Gemini here
  }

  ChatUser currentUser =
      ChatUser(id: "0", firstName: "User"); // define the users in the chat:
  ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: "Gemini",
    profileImage:
        "https://seeklogo.com/images/G/google-gemini-logo-A5787B2669-seeklogo.com.png",
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Gemini Chat",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          backgroundColor: AppColor.mainAppColor,
          actions: [
            IconButton(
              color: AppColor.subappcolor,
              icon: const Icon(Icons.rate_review),
              onPressed: () => _showReviewDialog(context),
            ),
          ],
        ),
        body: _buildUI(),
      ),
    );
  }

  Widget _buildUI() {
    return DashChat(
      inputOptions: InputOptions(trailing: [
        IconButton(
          onPressed: _sendMediaMessage,
          icon: const Icon(
            Icons.image,
          ),
        )
      ]),
      currentUser: currentUser,
      onSend: _sendMessage,
      messages: messages,
    );
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });

    try {
      String question = chatMessage.text;
      List<Uint8List>? images;
      if (chatMessage.medias?.isNotEmpty ?? false) {
        images = [
          File(chatMessage.medias!.first.url)
              .readAsBytesSync(), // send the image as base 64 to let the ui read it
        ];
      }

      gemini
          .streamGenerateContent(
        question,
        images: images,
      ) // a content generation request to Gemini and listens for responses
          .listen((event) {
        String response = event.content?.parts?.fold(
              "",
              (previous, current) => "$previous ${current.text}",
            ) ??
            "";

        setState(() {
          ChatMessage? lastMessage = messages.firstOrNull;
          if (lastMessage != null && lastMessage.user == geminiUser) {
            lastMessage.text = response;
            messages = [
              lastMessage,
              ...messages.skip(1)
            ]; // Preserve the rest of the messages
          } else {
            ChatMessage message = ChatMessage(
              user: geminiUser,
              createdAt: DateTime.now(),
              text: response,
            );
            messages = [message, ...messages];
          } //last message is from geminiUser. If it is, it updates the text of the last message. Otherwise, it creates a new message
          geminiResponse = response;
        }); //updates the state with the new list of messages and يسجل the response.

        print("response: $response");
      }).onError((error) {
        print("Error: $error");
      });
    } catch (e) {
      print(e);
    }
  }

  void _sendMediaMessage() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (file != null) {
      ChatMessage chatMessage = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        text: "Describe this picture?",
        medias: [
          ChatMedia(
            url: file.path,
            fileName: "",
            type: MediaType.image,
          )
        ],
      );
      _sendMessage(chatMessage);
    }
  }

  void _showReviewDialog(BuildContext context) {
    double rating = 0;
    TextEditingController reviewController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Submit a Review"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PannableRatingBar(
                    rate: rating,
                    items: List.generate(
                      5,
                      (index) => const RatingWidget(
                        selectedColor: Colors.yellow,
                        unSelectedColor: Colors.grey,
                        child: Icon(
                          Icons.star,
                          size: 48,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      // the rating value is updated on tap or drag.
                      setState(() {
                        rating = value;
                        print(rating);
                      });
                    },
                  ),
                  TextField(
                    controller: reviewController,
                    decoration: const InputDecoration(
                      hintText: "Write your review",
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await _submitReview(rating, reviewController.text);
                Navigator.of(context).pop();
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitReview(double rating, String review) async {
    await FirebaseFirestore.instance.collection('reviews').add({
      'rating': rating,
      'review': review,
      'userEmail': email ?? '',
    });
  }
}

extension IterableExtension<T> on Iterable<T> {
  T? get firstOrNull {
    if (isEmpty) return null;
    return first;
  }
}
