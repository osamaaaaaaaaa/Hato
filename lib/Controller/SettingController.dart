// ignore_for_file: file_names, prefer_const_constructors

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/Material.dart';
import 'package:get/get.dart';
import 'package:superconnect/Local/AppConst.dart';
import 'package:superconnect/Model/ItemDataModel.dart';
import 'package:superconnect/Utils/Helper.dart';
import 'package:vector_math/vector_math.dart' as math;
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/UserModel.dart';
import '../Utils/Colors.dart';
import '../View/Widgets/Button.dart';

class SettingController extends GetxController {
  var db = FirebaseFirestore.instance;
  var userId = FirebaseAuth.instance.currentUser?.uid;

  SettingController() {
    getInfo();
  }
  UserModel? info;
  getInfo() async {
    //loading = true;
    update();
    await db.collection('users').doc(userId).get().then((value) {
      if (value.data() != null) {
        info = UserModel.fromJson(value.data()!);
        getItemMangmentComparing();
      }
    });

    email.text = info!.email.toString();
    mobile.text = info!.mobile.toString();
    username.text = info!.name.toString();
    url = info?.image;

    update();
  }

  PlatformFile? pickedfile;
  UploadTask? uploadTask;
  bool loading = false;
  int gender = 0;
  switchGender() {
    if (gender == 0) {
      gender = 1;
      update();
    } else {
      gender = 0;
      update();
    }
  }

  // void _handleImageSelection() async {
  //   final result = await ImagePicker().pickImage(
  //     imageQuality: 70,
  //     maxWidth: 1440,
  //     source: ImageSource.gallery,
  //   );

  //   if (result != null) {
  //     final bytes = await result.readAsBytes();
  //     final image = await decodeImageFromList(bytes);
  //   }
  // }
  var email = TextEditingController();
  var pass = TextEditingController();
  var mobile = TextEditingController();
  var username = TextEditingController();

  editUser() {
    info?.email = email.text.toString();
    info?.mobile = mobile.text.toString();
    info?.name = username.text.toString();
    info?.image = url.toString();
    Get.back();

    AppHelper.succssessnackbar('');
    updateUser();
  }

  String? url;
  Future selectimage() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) {
      return;
    }
    pickedfile = result.files.first;
    update();
    _uploadtofirestorage();
    update();
  }

  _uploadtofirestorage() async {
    final path = 'images/${pickedfile!.name}';
    final file = File(pickedfile!.path!);
    final ref = FirebaseStorage.instance.ref(path);
    uploadTask = ref.putFile(file);
    final snapshot = await uploadTask!.whenComplete(() => {});
    url = await snapshot.ref.getDownloadURL();
    update();
  }

  List<ItemDataModel> itemsComparingList = [];
  bool itemcomparingLoading = false;
  getItemMangmentComparing() async {
    itemcomparingLoading = true;
    update();
    itemsComparingList.clear();
    await db
        .collection('items')
        .doc(userId)
        .collection('items')
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        itemcomparingLoading = false;
        update();
        return;
      }

      for (var e in value.docs) {
        itemsComparingList.add(ItemDataModel.fromJson(e.data()));
      }
      itemcomparingLoading = false;

      update();
    });
  }

  addToComparingList({required ItemDataModel model}) async {
    itemcomparingLoading = true;
    update();
    await db
        .collection('items')
        .doc(userId)
        .collection('items')
        .add(model.toJson())
        .then((value) async {
      model.id = value.id;
      await db
          .collection('items')
          .doc(userId)
          .collection('items')
          .doc(value.id)
          .update(model.toJson());
      await db.collection('items').doc(userId).set({});
    });
    getItemMangmentComparing();
    AppHelper.succssessnackbar('success');
  }

  delete_item(Index) {
    itemcomparingLoading = true;

    db
        .collection('items')
        .doc(userId)
        .collection('items')
        .doc(itemsComparingList[Index].id)
        .delete();
    itemsComparingList.removeAt(Index);

    itemcomparingLoading = false;
    update();
    AppHelper.succssessnackbar('success');
  }

  editFromComparingList({required ItemDataModel model}) async {
    await db
        .collection('items')
        .doc(userId)
        .collection('items')
        .doc(model.id)
        .update(model.toJson());
    getItemMangmentComparing();
    Get.back();

    AppHelper.succssessnackbar('success');
  }

  deletCategory(index) async {
    info?.categories?.removeAt(index);
    updateUser();
    update();
  }

  addCategory({required title, required String? image}) async {
    info?.categories?.add({"name": title, 'image': image});
    update();
    updateUser();
    AppHelper.succssessnackbar('');
  }

  updateUser() async {
    await db.collection('users').doc(userId).update(info!.toJson());
    url = null;
    update();
  }

  additemCategory({required context}) {
    showGeneralDialog(
      context: context,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        // var curve = Curves.easeInOut.transform(a1.value);
        return Transform.rotate(
          angle: math.radians(a1.value * 360),
          child: _addItemDialog(),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  _addItemDialog() {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25))),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              "cancel".tr,
              style: TextStyle(color: Colors.red, fontSize: 17),
            ))
      ],
    );
  }

  changeLang() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Get.defaultDialog(
        titlePadding: EdgeInsets.only(top: 10),
        title: 'lang'.tr,
        content: Column(children: [
          Container(
            margin: EdgeInsets.all(5),
            child: button(
                color: AppColors.color1,
                title: 'العربية',
                fontsize: 16,
                border: 25,
                fontColor: Colors.white,
                height: 50,
                function: () async {
                  await preferences.setString(AppConst.Lang, 'ar');
                  Restart.restartApp();
                },
                width: Get.width * 0.6),
          ),
          Container(
            margin: EdgeInsets.all(5),
            child: button(
                color: AppColors.color1,
                title: 'English',
                fontsize: 16,
                border: 25,
                fontColor: Colors.white,
                height: 50,
                function: () async {
                  await preferences.setString(AppConst.Lang, 'en');
                  Restart.restartApp();
                },
                width: Get.width * 0.6),
          ),
        ]));
  }
}
