// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, prefer_const_constructors, file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:superconnect/Controller/SettingController.dart';
import 'package:superconnect/Utils/Helper.dart';
import 'package:superconnect/View/Screens/Auth/Login.dart';
import 'package:superconnect/View/Widgets/TextField.dart';

import '../../../Utils/Colors.dart';
import '../../Widgets/Button.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(
      init: SettingController(),
      builder: (controller) => Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              InkWell(
                onTap: () {
                  controller.selectimage();
                },
                child: Center(
                  child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: AppColors.color1)),
                      height: 200,
                      width: 200,
                      child: Container(
                        alignment: Alignment.center,
                        child: controller.url != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.network(
                                  controller.url.toString(),
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.fill,
                                ))
                            : Icon(
                                Icons.add_a_photo,
                                size: 50,
                                color: AppColors.color1,
                              ),
                      )),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              TextFieldWidget(
                  controller: controller.username,
                  title: 'username'.tr,
                  enable: true,
                  iconData: Icons.abc,
                  IsPass: false,
                  width: Get.width * 0.9),

              TextFieldWidget(
                  controller: controller.mobile,
                  title: 'mobile'.tr,
                  enable: false,
                  iconData: Icons.mobile_friendly,
                  IsPass: false,
                  width: Get.width * 0.9),
              //    Gender(controller: controller),
              SizedBox(
                height: 50,
              ),
              controller.loading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : button(
                      color: AppColors.color1,
                      title: 'save'.tr,
                      fontsize: 15,
                      fontColor: Colors.white,
                      height: 40,
                      function: () {
                        if (controller.username.text.isEmpty ||
                            controller.mobile.text.isEmail) {
                          return;
                        }
                        if (controller.mobile.text.length < 5) {
                          AppHelper.errorsnackbar('mobile'.tr);
                          return;
                        }
                        controller.editUser();
                      },
                      width: Get.width * 0.9),

              button(
                  color: Colors.red,
                  title: 'deleteacc'.tr,
                  fontsize: 15,
                  fontColor: Colors.white,
                  height: 50,
                  function: () {
                    AppHelper().showAreSureMoreDialg(
                        title: 'deleteacc'.tr,
                        ontap: () {
                          FirebaseAuth.instance.currentUser?.delete();
                          Get.offAll(() => Login());
                        });
                  },
                  width: Get.width)
            ],
          ),
        ),
      ),
    );
  }
}

Widget Gender({required SettingController controller}) => Column(
      children: <Widget>[
        ListTile(
          title: Text('male'.tr),
          leading: Radio<int>(
            value: 0,
            activeColor: AppColors.color1,
            groupValue: controller.gender,
            onChanged: (dynamic value) {
              controller.switchGender();
            },
          ),
        ),
        ListTile(
          title: Text('female'.tr),
          leading: Radio<int>(
            value: 1,
            activeColor: AppColors.color1,
            groupValue: controller.gender,
            onChanged: (dynamic value) {
              controller.switchGender();
            },
          ),
        ),
      ],
    );
