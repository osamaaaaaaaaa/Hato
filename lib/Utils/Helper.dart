// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppHelper {
  static errorsnackbar(error) {
    return Get.snackbar('Error', error,
        backgroundColor: Colors.red, colorText: Colors.white);
  }

  static succssessnackbar(succs) {
    return Get.snackbar('Succsses', succs,
        backgroundColor: Colors.green, colorText: Colors.white);
  }
}
