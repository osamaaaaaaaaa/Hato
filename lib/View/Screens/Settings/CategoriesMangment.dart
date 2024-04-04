// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, file_names, unused_element

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:superconnect/Controller/SettingController.dart';
import 'package:superconnect/Utils/Colors.dart';
import 'package:superconnect/View/Widgets/AppBar.dart';
import 'package:superconnect/View/Widgets/TextField.dart';

class CategoriesMangment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(
        init: SettingController(),
        builder: (controller) => Scaffold(
              body: controller.info == null
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.grey,
                        backgroundColor: AppColors.color1,
                      ),
                    )
                  : Column(
                      children: [
                        App_Bar(
                            iconData: Icons.category,
                            title: 'cat'.tr,
                            color: AppColors.color1),
                        Expanded(
                            child: ListView.builder(
                          itemCount: (controller.info?.categories!.length)! + 1,
                          itemBuilder: (context, index) => index == 0
                              ? Container()
                              : (index + 1) ==
                                      (controller.info?.categories!.length)! + 1
                                  ? InkWell(
                                      onTap: () {
                                        _addNewCat(
                                            context: context,
                                            controller: controller);
                                      },
                                      child: _widget2())
                                  : _widget(
                                      controller: controller,
                                      cat: controller.info?.categories?[index],
                                      index: index),
                        ))
                      ],
                    ),
            ));
  }
}

Widget _widget(
    {required cat, required index, required SettingController controller}) {
  return Container(
    padding: EdgeInsets.all(5),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  controller.deletCategory(index);
                },
                child: Icon(
                  Icons.delete_forever,
                  color: Colors.red,
                ),
              ),
              Row(
                children: [
                  Text(
                    cat['name'].toString(),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.color1),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  cat['image'] != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            cat['image']!,
                            height: 40,
                            width: 40,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Color.fromARGB(53, 19, 68, 64),
                              borderRadius: BorderRadius.circular(10)),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: AppColors.color1,
                          ),
                        ),
                ],
              ),
            ],
          ),
        ),
        Divider()
      ],
    ),
  );
}

Widget _widget2() {
  return Container(
    color: AppColors.color1,
    padding: EdgeInsets.all(8),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                color: Colors.white,
              ),
              Text(
                'add'.tr,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

_addNewCat({
  required context,
  required SettingController controller,
}) {
  showGeneralDialog(
    context: context,
    pageBuilder: (ctx, a1, a2) {
      return Container();
    },
    transitionBuilder: (ctx, a1, a2, child) {
      var curve = Curves.easeInOut.transform(a1.value);
      return Transform.scale(
        scaleX: curve,
        scaleY: 1,
        child: _dialog(context: ctx, controller: controller),
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}

Widget _dialog({
  required BuildContext context,
  required SettingController controller,
}) {
  var ct = TextEditingController();
  return AlertDialog(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25))),
    backgroundColor: Colors.white,
    title: Text(
      "addcat".tr,
      style: TextStyle(color: AppColors.color1),
    ),
    content: Container(
      child: Row(
        children: [
          InkWell(
            onTap: () {
              selectimage(context: context, controller: controller);
            },
            child: url != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      url!,
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(53, 19, 68, 64),
                        borderRadius: BorderRadius.circular(10)),
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: AppColors.color1,
                    ),
                  ),
          ),
          Container(
            width: Get.width * 0.5,
            child: TextFieldWidget(
                controller: ct,
                title: 'name'.tr,
                enable: true,
                iconData: null,
                IsPass: false,
                width: Get.width * 0.5),
          )
        ],
      ),
    ),
    actions: <Widget>[
      TextButton(
          onPressed: () {
            url = null;
            Navigator.of(context).pop();
          },
          child: Text(
            "cancel".tr,
            style: TextStyle(color: Colors.red, fontSize: 17),
          )),
      TextButton(
          onPressed: () {
            if (ct.text.isEmpty) {
              return;
            }
            controller.addCategory(title: ct.text, image: url);
            Navigator.of(context).pop();
          },
          child: Text(
            "save".tr,
            style: TextStyle(color: Colors.green, fontSize: 17),
          ))
    ],
  );
}

PlatformFile? pickedfile;
UploadTask? uploadTask;
String? url;
Future selectimage({
  required BuildContext context,
  required SettingController controller,
}) async {
  final result = await FilePicker.platform.pickFiles();
  if (result == null) {
    return;
  }
  pickedfile = result.files.first;
  _uploadtofirestorage(context: context, controller: controller);
}

_uploadtofirestorage({
  required BuildContext context,
  required SettingController controller,
}) async {
  final path = 'images/${pickedfile!.name}';
  final file = File(pickedfile!.path!);
  final ref = FirebaseStorage.instance.ref(path);
  uploadTask = ref.putFile(file);
  final snapshot = await uploadTask!.whenComplete(() => {});
  url = await snapshot.ref.getDownloadURL();

  _addNewCat(context: context, controller: controller);
}
