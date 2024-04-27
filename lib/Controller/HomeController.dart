// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, no_leading_underscores_for_local_identifiers, unused_import, depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:superconnect/Model/UserModel.dart';
import 'package:superconnect/Services/ApiServices.dart';
import 'package:superconnect/Utils/Helper.dart';
import 'package:superconnect/View/Screens/Auth/Login.dart';
import 'package:superconnect/View/Screens/Chat/ChatsHistory.dart';
import 'package:superconnect/View/Screens/Chat/Conversation.dart';
import 'package:vector_math/vector_math.dart' as math;

import 'package:superconnect/View/Screens/Home/landing.dart';
import 'package:superconnect/View/Screens/requests.dart/AddRequest.dart';
import 'package:superconnect/View/Screens/requests.dart/RequestFromYouList.dart';
import 'package:superconnect/View/Screens/requests.dart/RequestToYouList.dart';

import '../Utils/Colors.dart';
import '../View/Widgets/Button.dart';
import '../View/Widgets/TextField.dart';

class HomeController extends GetxController {
  var db = FirebaseFirestore.instance;
  var user = FirebaseAuth.instance.currentUser?.uid;
  //Widget widget = Home();
  UserModel? info;
  bool guest = false;
  List<UserModel> familyList = [];
  HomeController() {
    getInfo();
  }
  bool? loading = true;
  getInfo() async {
    loading = true;
    update();
    await db.collection('users').doc(user).get().then((value) async {
      if (value.data() != null) {
        info = UserModel.fromJson(value.data()!);
        if (info?.name == 'guest') {
          guest = true;
          update();
        }
        getFamily();
        getRequests();
        info?.token = await FirebaseMessaging.instance.getToken();
        await db.collection('users').doc(user).update(info!.toJson());
      }
    });

    update();
  }

  Stream<dynamic> getSingleUser(String uid) {
    final user = db.collection('users');
    return user
        .snapshots()
        .map((event) => event.docs.map((e) => e.data())); //<--- change this
  }

  getFamily() async {
    familyList.clear();
    if (info!.family!.isNotEmpty) {
      for (var element in info!.family!) {
        await db.collection('users').doc(element).get().then((value) {
          if (value.data() != null) {
            familyList.add(UserModel.fromJson(value.data()!));
          }
        });
        update();
      }
    }
    loading = false;
    update();
  }

  addNewFamilyMember() {
    var _controller = TextEditingController();
    Get.defaultDialog(
        title: 'addfamily'.tr,
        content: Column(
          children: [
            TextFieldWidget(
                controller: _controller,
                title: 'id'.tr,
                enable: true,
                iconData: Icons.abc,
                IsPass: false,
                width: Get.width * 0.6),
            button(
                color: AppColors.color1,
                title: 'continue'.tr,
                fontsize: 15,
                fontColor: Colors.white,
                height: 50,
                function: () {
                  if (_controller.text.isEmpty) {
                    return;
                  }
                  _addNewFamilyMember(id: _controller.text.trim());
                  Get.back();
                },
                width: 150),
          ],
        ));
  }

  _addNewFamilyMember({required id}) async {
    _loding();

    await db
        .collection('users')
        .where('idNo', isEqualTo: id.toString())
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        if (info!.family!.contains(value.docs[0].id)) {
          Get.back();
          Get.back();
          AppHelper.errorsnackbar('userAlredyexist');

          return;
        }
        info?.family?.add(value.docs[0].id.toString());
        getFamily();

        await db.collection('users').doc(user).update(info!.toJson());
        await db
            .collection('users')
            .doc(value.docs[0].id)
            .get()
            .then((value2) async {
          UserModel _anotherperson = UserModel.fromJson(value2.data()!);
          _anotherperson.family?.add(user!);
          await db
              .collection('users')
              .doc(value.docs[0].id)
              .update(_anotherperson.toJson());
        });

        Get.back();
        Get.back();
        ApiServices().sendNotification(
            body:
                'Hi ${familyList[familyList.indexWhere((element) => element.idNo == id)].name}',
            title: 'لقد اضفتك الى عائلتي !',
            token: familyList[
                    familyList.indexWhere((element) => element.idNo == id)]
                .token);
        return;
      }
      Get.back();
      Get.back();
      AppHelper.errorsnackbar('error');
    });
    update();
  }

  // personTap({required ReciverId, required context}) {
  //   showGeneralDialog(
  //     context: context,
  //     pageBuilder: (ctx, a1, a2) {
  //       return Container();
  //     },
  //     transitionBuilder: (ctx, a1, a2, child) {
  //       var curve = Curves.easeInOut.transform(a1.value);
  //       return Transform.scale(
  //         scaleX: curve,
  //         scaleY: 1,
  //         child: _dialog(ctx, ReciverId),
  //       );
  //     },
  //     transitionDuration: const Duration(milliseconds: 300),
  //   );
  // }

  // Widget _dialog(BuildContext context, ReciverId) {
  //   return AlertDialog(
  //     shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.all(Radius.circular(25))),
  //     backgroundColor: AppColors.color1,
  //     title: Text(
  //       "choose".tr,
  //       style: TextStyle(color: Colors.white),
  //     ),
  //     content: Container(
  //       height: 145,
  //       child: Column(
  //         children: [
  //           InkWell(
  //             onTap: () {
  //               Get.back();
  //               // Get.to(() => AddRequest(
  //               //       ReciverId: ReciverId,
  //               //     ));
  //               //   _addRequestDailog(userId: userId, name: '', note: '');

  //               showMaterialModalBottomSheet(
  //                 context: context,
  //                 builder: (context) => Container(
  //                   height: Get.height * 0.5,
  //                   child: ListView.builder(
  //                     itemCount: info?.categories?.length,
  //                     itemBuilder: (context, index) => InkWell(
  //                       onTap: () {
  //                         if (index == 0) {
  //                           return;
  //                         }
  //                         // Get.to(() => AddRequest(
  //                         //       ReciverId: ReciverId,
  //                         //       cat: info?.categories![index],
  //                         //     ));
  //                       },
  //                       child: Column(children: [
  //                         Text(
  //                           info?.categories![index],
  //                           style: TextStyle(
  //                               fontSize: 16, fontWeight: FontWeight.bold),
  //                         ),
  //                         Divider(
  //                           thickness: 1.5,
  //                         )
  //                       ]),
  //                     ),
  //                   ),
  //                 ),
  //               );
  //             },
  //             child: Container(
  //               alignment: Alignment.center,
  //               width: 130,
  //               height: 50,
  //               margin: const EdgeInsets.all(10),
  //               decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.circular(20)),
  //               child: Row(
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Icon(
  //                     Icons.question_mark_outlined,
  //                     color: AppColors.color1,
  //                   ),
  //                   SizedBox(
  //                     width: 10,
  //                   ),
  //                   Text(
  //                     'order'.tr,
  //                     style: TextStyle(
  //                         color: Colors.grey,
  //                         fontSize: 17,
  //                         fontWeight: FontWeight.bold),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //           InkWell(
  //             onTap: () {
  //               Get.back();
  //               Get.to(() => Conversation(
  //                     model: info,
  //                     ReciverId: ReciverId,
  //                     userId: user,
  //                   ));
  //               //   _addRequestDailog(userId: userId, name: '', note: '');
  //             },
  //             child: Container(
  //               alignment: Alignment.center,
  //               width: 130,
  //               height: 50,
  //               margin: const EdgeInsets.all(10),
  //               decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.circular(20)),
  //               child: Row(
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Icon(
  //                     Icons.chat_rounded,
  //                     color: AppColors.color1,
  //                   ),
  //                   SizedBox(
  //                     width: 10,
  //                   ),
  //                   Text(
  //                     'chat'.tr,
  //                     style: TextStyle(
  //                         color: Colors.grey,
  //                         fontSize: 17,
  //                         fontWeight: FontWeight.bold),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //     actions: <Widget>[
  //       TextButton(
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //           },
  //           child: Text(
  //             "cancel".tr,
  //             style: TextStyle(color: Colors.red, fontSize: 17),
  //           ))
  //     ],
  //   );
  // }

  int getPersonData({required userId}) {
    return familyList.indexWhere((element) => element.id == userId);
  }

  List<Request> requestsToyou = [];
  List<Request> requestsFromyou = [];

  getRequests() {
    requestsToyou.clear();
    requestsFromyou.clear();
    if (info!.request!.isNotEmpty)
      requestsToyou = List.from(info!.request!
          .where((element) => element.reciverId == user)
          .toList());
    requestsToyou.sort(
      (a, b) => b.createdDate!.compareTo(a.createdDate!),
    );
    requestsFromyou = List.from(
        info!.request!.where((element) => element.senderId == user).toList());
    requestsFromyou.sort(
      (a, b) => b.createdDate!.compareTo(a.createdDate!),
    );
    update();
  }

  updateRequestStatus(
      {required Request request, required int stat, String? note}) async {
    info?.request
        ?.where((element) => element.id == request.id.toString())
        .toList()
        .first
        .status = stat;
    info?.request
        ?.where((element) => element.id == request.id.toString())
        .toList()
        .first
        .note = note;
    await db.collection('users').doc(user).update(info!.toJson());
    await db
        .collection('users')
        .doc(request.senderId)
        .get()
        .then((value) async {
      UserModel _model = UserModel.fromJson(value.data()!);
      _model.request
          ?.where((element) => element.id == request.id.toString())
          .toList()
          .first
          .status = stat;
      _model.request
          ?.where((element) => element.id == request.id.toString())
          .toList()
          .first
          .note = note;
      await db
          .collection('users')
          .doc(request.senderId)
          .update(_model.toJson());
    });
    update();
  }

  DeleteReq({
    required Request request,
  }) async {
    info?.request?.remove(request);

    await db.collection('users').doc(user).update(info!.toJson());
    getInfo();
    update();
  }

  signOut() async {
    await FirebaseAuth.instance.signOut();
    Get.offAll(() => Login());
  }

  _loding() {
    Get.defaultDialog(
        backgroundColor: Colors.transparent,
        content: const Center(
          child: CircularProgressIndicator(),
        ));
  }

  Widget widget = landing();
  int selectedindex = 0;
  List list = ['home'.tr, 'allrequests'.tr, 'allrequired'.tr, 'chat'.tr];
  List<Widget> widgets = [
    landing(),
    RequestFromYouList(),
    RequestToYouList(),
    ChatsHistory()
  ];
}
