// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:superconnect/Utils/Colors.dart';
import 'package:superconnect/View/Screens/Auth/Login.dart';
import 'package:superconnect/View/Widgets/Button.dart';

class AppHelper {
  static errorsnackbar(error) {
    return Get.snackbar('Error', error,
        backgroundColor: Colors.red, colorText: Colors.white);
  }

  static succssessnackbar(succs) {
    return Get.snackbar('Succsses', succs,
        backgroundColor: Colors.green, colorText: Colors.white);
  }

  showAreSureMoreDialg({required String? title, required Function() ontap}) {
    Get.defaultDialog(
        content: Container(),
        title: title ?? 'Are u Sure ?',
        actions: [
          button(
              color: AppColors.color1,
              title: 'ok'.tr,
              fontsize: 15,
              fontColor: Colors.white,
              height: 40,
              function: ontap,
              width: Get.width / 2),
          button(
              color: Colors.red,
              title: 'cancel'.tr,
              fontsize: 15,
              fontColor: Colors.white,
              height: 40,
              function: () {
                Get.back();
              },
              width: Get.width / 2)
        ]);
  }

  shouldSignin() {
    Get.defaultDialog(
        title: '',
        content: Text(
          'shoulsignin'.tr,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          button(
              color: Colors.green,
              title: 'continue'.tr,
              fontsize: 15,
              fontColor: Colors.white,
              height: 40,
              function: () {
                Get.to(() => Login());
              },
              width: Get.width),
          button(
              color: Colors.red,
              title: 'cancel'.tr,
              fontsize: 15,
              fontColor: Colors.white,
              height: 40,
              function: () {
                Get.back();
              },
              width: Get.width)
        ]);
  }

  addmobile() {
    Get.defaultDialog(
        title: '',
        content: Text(
          'addmobile'.tr,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          button(
              color: Colors.green,
              title: 'ok'.tr,
              fontsize: 15,
              fontColor: Colors.white,
              height: 40,
              function: () {
                Get.back();
              },
              width: Get.width),
        ]);
  }

  errorDialog({required title}) {
    Get.defaultDialog(
        title: '',
        content: Text(
          '$title',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          button(
              color: Colors.green,
              title: 'ok'.tr,
              fontsize: 15,
              fontColor: Colors.white,
              height: 40,
              function: () {
                Get.back();
              },
              width: Get.width),
        ]);
  }
}
