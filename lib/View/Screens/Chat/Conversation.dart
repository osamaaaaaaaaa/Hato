// ignore_for_file: depend_on_referenced_packages, unused_import, non_constant_identifier_names, must_be_immutable, no_logic_in_create_state

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:superconnect/Controller/ChatController.dart';
import 'package:superconnect/Controller/HomeController.dart';
import 'package:superconnect/Model/UserModel.dart';
import 'package:superconnect/Utils/Colors.dart';
import 'package:uuid/uuid.dart';

import '../../../Services/ApiServices.dart';

class Conversation extends StatefulWidget {
  String? ReciverId, userId;
  UserModel? model;
  Conversation(
      {super.key,
      required this.ReciverId,
      required this.userId,
      required this.model});

  @override
  State<Conversation> createState() =>
      _ChatPageState(ReciverId: ReciverId, userId: userId, model: model);
}

Future<String?>? _getuser() async {
  var user = await FirebaseAuth.instance.currentUser?.uid.toString();

  return user;
}

class _ChatPageState extends State<Conversation> {
  String? ReciverId, userId;
  UserModel? model;

  HomeController contr = Get.put(HomeController());

  var _user;

  _ChatPageState(
      {required this.ReciverId, required this.userId, required this.model}) {
    _user = types.User(
        id: userId!,
        firstName: model?.name.toString(),
        lastName: '',
        imageUrl: model?.image);
  }
  List<types.Message> _messages = [];
  CollectionReference msgs = FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _addMessage(types.Message message) async {
    var db = FirebaseFirestore.instance;
    await db
        .collection('users')
        .doc(userId)
        .collection('chats')
        .doc(ReciverId)
        .collection('msgs')
        .add(message.toJson());
    await db
        .collection('users')
        .doc(ReciverId)
        .collection('chats')
        .doc(userId)
        .collection('msgs')
        .add(message.toJson());

    await db
        .collection('users')
        .doc(userId)
        .collection('chats')
        .doc(ReciverId)
        .set({'last': message.toJson()});
    await db
        .collection('users')
        .doc(ReciverId)
        .collection('chats')
        .doc(userId)
        .set({'last': message.toJson()});
    ApiServices().sendNotification(
        body: message.toJson()['text'].toString(),
        title: model?.name,
        image: model?.image,
        token: contr
            .familyList[contr.familyList
                .indexWhere((element) => element.id == ReciverId)]
            .token);
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 110,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Row(
                    children: [
                      const Icon(Icons.photo),
                      const SizedBox(
                        width: 5,
                      ),
                      Text('Photo'.tr),
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Row(
                    children: [
                      const Icon(Icons.cancel_outlined),
                      const SizedBox(
                        width: 5,
                      ),
                      Text('Cancel'.tr),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      _addMessage(message);
    }
  }

  PlatformFile? pickedfile;
  UploadTask? uploadTask;
  void _handleImageSelection() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        pickedfile = result.files.first;
      });

      final path = 'images/${pickedfile!.name}';
      final file = File(pickedfile!.path!);
      final ref = FirebaseStorage.instance.ref(path);
      uploadTask = ref.putFile(file);
      final snapshot = await uploadTask!.whenComplete(() => {});
      var url = await snapshot.ref.getDownloadURL();
      final message = types.ImageMessage(
          author: _user,
          createdAt: DateTime.now().toUtc().millisecondsSinceEpoch,
          //height:pickedfile.bytes!.height.toDouble(),
          id: const Uuid().v4(),
          name: pickedfile!.name.toString(),
          size: 200,
          uri: url,
          metadata: {"user": ''}
          // width: image.width.toDouble(),
          );

      _addMessage(message);
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });
  }

  void _handleSendPressed(types.PartialText message) async {
    final textMessage = types.TextMessage(
        author: _user,
        createdAt: await _getMessagesLength(),
        id: const Uuid().v4(),
        text: message.text,
        metadata: {"date": DateTime.now().toString()});

    _addMessage(textMessage);
  }

  void _loadMessages() async {
    final response = ms;
    final messages = response
        .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
        .toList();

    setState(() {
      _messages = messages;
    });
  }

  Future<int> _getMessagesLength() async {
    var db = FirebaseFirestore.instance;
    var x = 0;
    await db
        .collection('users')
        .doc(userId)
        .collection('chats')
        .doc(ReciverId)
        .collection('msgs')
        .get()
        .then((value) => x = value.docs.length);
    return x;
  }

  Stream<dynamic> _getMessages() {
    var db = FirebaseFirestore.instance;

    final msgs = db
        .collection('users')
        .doc(userId)
        .collection('chats')
        .doc(ReciverId)
        .collection('msgs')
        .orderBy('createdAt', descending: true);
    return msgs.snapshots().map((event) => event.docs
        .map((e) => types.Message.fromJson(e.data() as Map<String, dynamic>))
        .toList()); //<--- change this
  }

  @override
  Widget build(BuildContext context) => GetBuilder<ChatController>(
        init: ChatController(),
        builder: (controller) => Scaffold(
          body: StreamBuilder(
            stream: _getMessages(),
            builder: (context, snapshot) => Chat(
              messages: !snapshot.hasData ? _messages : snapshot.data,
              onAttachmentPressed: _handleAttachmentPressed,
              onMessageTap: _handleMessageTap,
              onPreviewDataFetched: _handlePreviewDataFetched,
              onSendPressed: _handleSendPressed,
              showUserAvatars: true,
              showUserNames: true,
              user: _user,
              hideBackgroundOnEmojiMessages: true,
              dateIsUtc: true,
              theme: DefaultChatTheme(
                  dateDividerTextStyle: TextStyle(color: Colors.white),
                  inputTextStyle: const TextStyle(color: Colors.white),
                  inputBackgroundColor: AppColors.color1.withOpacity(0.8),
                  inputTextColor: Colors.white,
                  primaryColor: AppColors.color1),
            ),
          ),
        ),
      );
}

var ms = [
  // {
  //   "author": {
  //     "firstName": "John",
  //     "id": "4c2307ba-3d40-442f-b1ff-b271f63904ca",
  //     "lastName": "Doe"
  //   },
  //   "createdAt": 1655648404000,
  //   "id": "c67ed376-52bf-4d4e-ba2a-7a0f8467b22a",
  //   "status": "seen",
  //   "text": "Ooowww ☺️",
  //   "type": "text"
  // },
  // {
  //   "author": {
  //     "firstName": "Janice",
  //     "id": "e52552f4-835d-4dbe-ba77-b076e659774d",
  //     "imageUrl":
  //         "https://i.pravatar.cc/300?u=e52552f4-835d-4dbe-ba77-b076e659774d",
  //     "lastName": "King"
  //   },
  //   "createdAt": 1655648403000,
  //   "height": 1280,
  //   "id": "02797655-4d73-402e-a319-50fde79e2bc4",
  //   "name": "madrid",
  //   "size": 585000,
  //   "status": "seen",
  //   "type": "image",
  //   "uri":
  //       "https://firebasestorage.googleapis.com/v0/b/stepcounter-b8d39.appspot.com/o/eniko-kis-KsLPTsYaqIQ-unsplash.jpg?alt=media&token=08af1a28-0de0-4d31-a01a-1fcaed8d2f73",
  //   "width": 1920
  // },
  // {
  //   "author": {
  //     "firstName": "Janice",
  //     "id": "e52552f4-835d-4dbe-ba77-b076e659774d",
  //     "imageUrl":
  //         "https://i.pravatar.cc/300?u=e52552f4-835d-4dbe-ba77-b076e659774d",
  //     "lastName": "King"
  //   },
  //   "createdAt": 1655648402000,
  //   "id": "4e048753-2d60-4144-bc28-9967050aaf12",
  //   "status": "seen",
  //   "text": "What a ~nice~ _wonderful_ sunset! 😻",
  //   "type": "text"
  // },
  // {
  //   "author": {
  //     "firstName": "Matthew",
  //     "id": "82091008-a484-4a89-ae75-a22bf8d6f3ac",
  //     "lastName": "White"
  //   },
  //   "createdAt": 1655648401000,
  //   "id": "64747b28-df19-4a0c-8c47-316dc3546e3c",
  //   "status": "seen",
  //   "text": "Here you go buddy! 💪",
  //   "type": "text"
  // },
  // {
  //   "author": {
  //     "firstName": "Matthew",
  //     "id": "82091008-a484-4a89-ae75-a22bf8d6f3ac",
  //     "lastName": "White"
  //   },
  //   "createdAt": 1655648400000,
  //   "id": "6a1a4351-cf05-4d0c-9d0f-47ed378b6112",
  //   "mimeType": "application/pdf",
  //   "name": "city_guide-madrid.pdf",
  //   "size": 10550000,
  //   "status": "seen",
  //   "type": "file",
  //   "uri":
  //       "https://www.esmadrid.com/sites/default/files/documentos/madrid_imprescindible_2016_ing_web_0.pdf"
  // },
  // {
  //   "author": {
  //     "firstName": "John",
  //     "id": "4c2307ba-3d40-442f-b1ff-b271f63904ca",
  //     "lastName": "Doe"
  //   },
  //   "createdAt": 1655624464000,
  //   "id": "38681a33-2563-42aa-957b-cfc12f791d16",
  //   "status": "seen",
  //   "text": "Matt, where is my Madrid guide?",
  //   "type": "text"
  // },
  // {
  //   "author": {
  //     "firstName": "Matthew",
  //     "id": "82091008-a484-4a89-ae75-a22bf8d6f3ac",
  //     "lastName": "White"
  //   },
  //   "createdAt": 1655624463000,
  //   "id": "113bb2e8-f74e-42cd-aa30-4085a0f52c58",
  //   "status": "seen",
  //   "text": "Awesome! 😍",
  //   "type": "text"
  // },
  // {
  //   "author": {
  //     "firstName": "Janice",
  //     "id": "e52552f4-835d-4dbe-ba77-b076e659774d",
  //     "imageUrl":
  //         "https://i.pravatar.cc/300?u=e52552f4-835d-4dbe-ba77-b076e659774d",
  //     "lastName": "King"
  //   },
  //   "createdAt": 1655624462000,
  //   "id": "22212d42-1252-4641-9786-d6f83b2ce4a8",
  //   "status": "seen",
  //   "text": "Matt, what do you think?",
  //   "type": "text"
  // },
  // {
  //   "author": {
  //     "firstName": "Janice",
  //     "id": "e52552f4-835d-4dbe-ba77-b076e659774d",
  //     "imageUrl":
  //         "https://i.pravatar.cc/300?u=e52552f4-835d-4dbe-ba77-b076e659774d",
  //     "lastName": "King"
  //   },
  //   "createdAt": 1655624461000,
  //   "id": "afc2269a-374b-4382-8864-b3b60d1e8cd7",
  //   "status": "seen",
  //   "text": "Yeah! Together with Demna, Mark Hamill and others 🥰",
  //   "type": "text"
  // },
  // {
  //   "author": {
  //     "firstName": "John",
  //     "id": "4c2307ba-3d40-442f-b1ff-b271f63904ca",
  //     "lastName": "Doe"
  //   },
  //   "createdAt": 1655624460000,
  //   "id": "634b2f0b-2486-4bfe-b36d-1c7d6313c7b3",
  //   "status": "seen",
  //   "text":
  //       "Guys! Did you know Imagine Dragons became ambassadors for u24.gov.ua ?",
  //   "type": "text"
  // }
];
