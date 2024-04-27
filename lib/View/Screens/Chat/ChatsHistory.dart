// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sized_box_for_whitespace, depend_on_referenced_packages, use_key_in_widget_constructors, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:superconnect/Controller/ChatController.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:superconnect/Utils/Helper.dart';
import 'package:superconnect/Utils/Images.dart';
import 'package:superconnect/View/Screens/Chat/Conversation.dart';
import 'package:superconnect/View/Screens/Chat/groupConversation.dart';
import 'package:superconnect/View/Widgets/Person.dart';

import '../../../Utils/Colors.dart';

class ChatsHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
        init: ChatController(),
        builder: (controller) => Container(
            alignment: Alignment.center,
            height: Get.height * 0.7,
            width: Get.width,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.white),
            child: controller.getchatsLoading!
                ? LinearProgressIndicator(
                    backgroundColor: AppColors.color1,
                    color: Colors.grey,
                  )
                : Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(color: Colors.grey, blurRadius: 20)
                            ],
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                left: 10,
                                right: 10,
                                top: 10,
                              ),
                              child: Text(
                                'groups'.tr,
                                style: TextStyle(
                                    color: AppColors.color1,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Divider(),
                            SizedBox(
                                height: 105,
                                width: Get.width - 100,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                        (controller.groupsList.length) + 1,
                                    itemBuilder: (context, index) => index +
                                                1 ==
                                            (controller.groupsList.length) + 1
                                        ? InkWell(
                                            onTap: () {
                                              if (controller.info?.name ==
                                                  'guest') {
                                                AppHelper().shouldSignin();
                                                return;
                                              }
                                              controller.addNewGroup();
                                            },
                                            child: Person(
                                                name: 'add'.tr,
                                                image:
                                                    'https://firebasestorage.googleapis.com/v0/b/famcon-acdde.appspot.com/o/992651.png?alt=media&token=a328f29d-dbc0-4248-a82e-3b19516c9b94',
                                                gender: 0),
                                          )
                                        : InkWell(
                                            onTap: () {
                                              Get.to(() => groupConversation(
                                                  groupmodel: controller
                                                      .groupsList[index],
                                                  ReciverId: controller
                                                      .groupsList[index]
                                                      .groupId,
                                                  userId: controller.userId,
                                                  model: controller.info));
                                            },
                                            child: Person(
                                                name: controller
                                                    .groupsList[index].groupName
                                                    .toString(),
                                                image: null,
                                                imageassets: AppImages.group,
                                                gender: 0),
                                          ))),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                            physics: ScrollPhysics(),
                            itemCount: controller.chatHitoryList.length,
                            itemBuilder: (context, index) => InkWell(
                                  onTap: () {
                                    Get.to(() => Conversation(
                                        model: controller.info,
                                        ReciverId: controller
                                            .chatHitoryList[index]
                                            .metadata?['user']['id'],
                                        userId: controller.userId));
                                  },
                                  child: _widget(
                                      message:
                                          controller.chatHitoryList[index]),
                                )),
                      ),
                    ],
                  )));
  }
}

Widget _widget({required types.Message message}) {
  return Container(
    margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 20)]),
    child: Row(
      children: [
        Person(
            name: null,
            image: message.metadata?['user']['image'],
            gender: message.metadata?['user']['gender']),
        SizedBox(
          width: 10,
        ),
        Container(
          height: 70,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      constraints: BoxConstraints(maxWidth: Get.width * 0.4),
                      child: Text(
                        message.metadata!['user']['name'].toString(),
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      )),
                ],
              ),
              Container(
                  constraints: BoxConstraints(maxWidth: Get.width * 0.5),
                  child: Text(
                    message.toJson()['text'].toString(),
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                  )),
              Text(
                DateFormat.MMMd()
                    .add_jm()
                    .format(DateFormat("yyyy-MM-dd hh:mm:ss")
                        .parse(message.metadata?['date']))
                    .toString(),
                style: TextStyle(fontSize: 13, color: AppColors.color1),
              )
            ],
          ),
        )
      ],
    ),
  );
}
