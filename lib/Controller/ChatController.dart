// ignore_for_file: depend_on_referenced_packages, file_names, no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/Material.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:superconnect/Model/groupModel.dart';
import 'package:superconnect/Utils/Helper.dart';

import '../Model/UserModel.dart';
import '../Utils/Colors.dart';
import '../View/Widgets/Button.dart';
import '../View/Widgets/TextField.dart';

class ChatController extends GetxController {
  var db = FirebaseFirestore.instance;
  var userId = FirebaseAuth.instance.currentUser?.uid;
  ChatController() {
    getInfo();
  }
  UserModel? info;

  getInfo() async {
    getchatsLoading = true;

    update();
    await db.collection('users').doc(userId).get().then((value) {
      if (value.data() != null) {
        info = UserModel.fromJson(value.data()!);
        getFamily();
      }
    });

    update();
  }

  List<UserModel> familyList = [];

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
      getChatHistory();
      getgroups();
    } else {
      getchatsLoading = false;
      update();
    }
    update();
  }

  int getPersonById({required userId}) {
    return familyList.indexWhere((element) => element.id == userId);
  }

  int getPersonByIdNo({required userId}) {
    return familyList.indexWhere((element) => element.idNo == userId);
  }

  List<types.Message> chatHitoryList = [];
  bool? getchatsLoading = false;
  getChatHistory() async {
    getchatsLoading = true;
    await db
        .collection('users')
        .doc(userId)
        .collection('chats')
        .get()
        .then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        chatHitoryList
            .add(types.Message.fromJson(value.docs[i].data()['last']));
        chatHitoryList[i].metadata?['user'] =
            familyList[getPersonById(userId: value.docs[i].id.toString())]
                .toJson();
      }
      getchatsLoading = false;

      update();
    });
  }

  List<groupModel> groupsList = [];

  getgroups() async {
    groupsList.clear();
    getchatsLoading = true;

    for (var e in info!.groups!) {
      await db.collection('groups').doc(e).get().then((value) {
        if (value.data() != null) {
          groupsList.add(groupModel.fromJson(value.data()!));
        }
      });
    }
    getchatsLoading = false;

    update();
  }

  updateGroup({required groupModel model}) async {
    await db.collection('groups').doc(model.groupId).update(model.toJson());
    for (var e in familyList) {
      await db.collection('users').doc(e.id).get().then((value) {
        UserModel _model = UserModel.fromJson(value.data()!);
        if (_model.groups!.contains(model.groupId)) {
          _model.groups?.remove(model.groupId);
        } else {
          _model.groups?.add(model.groupId);
        }
      });
      update();
    }
  }

  addMemberTogroup({required userId, required grupId}) async {
    await db.collection('users').doc(userId).get().then((value) async {
      if (value.data() != null) {
        UserModel model = UserModel.fromJson(value.data()!);
        if (model.groups!.contains(grupId)) {
          model.groups?.remove(grupId);
          await db.collection('users').doc(userId).update(model.toJson());
          await db.collection('groups').doc(grupId).get().then((value) {
            if (value.data() != null) {
              groupModel _groupmodel = groupModel.fromJson(value.data()!);
              if (_groupmodel.members!.contains(userId)) {
                _groupmodel.members?.remove(userId);
                db
                    .collection('groups')
                    .doc(grupId)
                    .update(_groupmodel.toJson());
                return;
              }
              _groupmodel.members?.add(userId);
              db.collection('groups').doc(grupId).update(_groupmodel.toJson());
            }
          });
          return;
        }
        model.groups?.add(grupId);
        await db.collection('users').doc(userId).update(model.toJson());

        await db.collection('groups').doc(grupId).get().then((value) {
          if (value.data() != null) {
            groupModel _groupmodel = groupModel.fromJson(value.data()!);
            if (_groupmodel.members!.contains(userId)) {
              _groupmodel.members?.remove(userId);
              db.collection('groups').doc(grupId).update(_groupmodel.toJson());
              return;
            }
            _groupmodel.members?.add(userId);
            db.collection('groups').doc(grupId).update(_groupmodel.toJson());
          }
        });
        AppHelper.succssessnackbar('succs');
      }
    });
  }

  removeMemberFromGroup({required userId, required grupId}) async {
    await db.collection('users').doc(userId).get().then((value) async {
      if (value.data() != null) {
        UserModel model = UserModel.fromJson(value.data()!);
        model.groups?.remove(grupId);
        await db.collection('users').doc(userId).update(model.toJson());
      }
    });
  }

  addNewGroup() {
    var _controller = TextEditingController();
    Get.defaultDialog(
        title: '',
        content: Column(
          children: [
            TextFieldWidget(
                controller: _controller,
                title: 'grname'.tr,
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
                  groupModel model = groupModel(
                    groupName: _controller.text.trim(),
                  );
                  _addNewGroup(model: model);
                  Get.back();
                },
                width: 150),
          ],
        ));
  }

  _addNewGroup({required groupModel model}) async {
    model.groupId = '${info?.idNo}${DateTime.now().millisecond}';
    model.members = [userId];
    await db
        .collection('groups')
        .doc(model.groupId)
        .set(model.toJson())
        .then((value) {});
    info?.groups?.add(model.groupId);
    update();
    updateUser();
    getgroups();
  }

  updateUser() async {
    await db.collection('users').doc(userId).update(info!.toJson());
  }
}
