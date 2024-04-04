// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:superconnect/Controller/AuthController.dart';
import 'package:superconnect/Utils/Images.dart';
import 'package:superconnect/View/Widgets/TextField.dart';

import '../../../Utils/Colors.dart';
import '../../Widgets/Button.dart';

class CodeInsert extends StatelessWidget {
  var email = TextEditingController();
  var pass = TextEditingController();
  var mobile = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      init: AuthController(),
      builder: (controller) => Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              Image.asset(AppImages.logo),
              const SizedBox(
                height: 20,
              ),
              TextFieldWidget(
                  controller: mobile,
                  title: 'code'.tr,
                  enable: true,
                  iconData: Icons.code_off,
                  IsPass: false,
                  width: Get.width * 0.9),
              controller.loading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : button(
                      color: AppColors.color1,
                      title: 'continue'.tr,
                      fontsize: 15,
                      fontColor: Colors.white,
                      height: 40,
                      function: () {
                        controller.checkuser(smscode: mobile.text.trim());
                      },
                      width: Get.width * 0.9),
            ],
          ),
        ),
      ),
    );
  }
}
