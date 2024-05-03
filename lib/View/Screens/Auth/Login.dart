// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:superconnect/Controller/AuthController.dart';
import 'package:superconnect/Model/UserModel.dart';
import 'package:superconnect/Utils/Helper.dart';
import 'package:superconnect/Utils/Images.dart';
import 'package:superconnect/View/Screens/Auth/Register.dart';
import 'package:superconnect/View/Screens/guest/guest.dart';

import '../../../Utils/Colors.dart';
import '../../Widgets/Button.dart';

class Login extends StatelessWidget {
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
                height: 50,
              ),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  alignment: Get.locale.toString() == 'ar'
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Text(
                    'addmobile'.tr,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.color1),
                  )),
              SizedBox(
                height: 15,
              ),
              Container(
                width: Get.width * 0.85,
                height: 50,
                margin: EdgeInsets.symmetric(horizontal: 17),
                child: InternationalPhoneNumberInput(
                  inputDecoration: InputDecoration(
                      label: Text('mobile'.tr),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onInputChanged: (PhoneNumber number) {
                    print(number.phoneNumber);
                    mobile.text = number.phoneNumber.toString();
                  },
                  onInputValidated: (bool value) {
                    print(value);
                  },
                  selectorConfig: SelectorConfig(
                    selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                  ),
                  ignoreBlank: true,
                  autoValidateMode: AutovalidateMode.disabled,
                  selectorTextStyle: TextStyle(color: Colors.black),
                  formatInput: false,
                  keyboardType: TextInputType.numberWithOptions(
                      decimal: false, signed: false),
                  inputBorder: OutlineInputBorder(),
                  onSaved: (PhoneNumber number) {
                    print('On Saved: $number');
                  },
                ),
              ),
              SizedBox(
                height: 50,
              ),
              controller.loading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : button(
                      color: AppColors.color1,
                      title: 'signin'.tr,
                      fontsize: 15,
                      fontColor: Colors.white,
                      height: 40,
                      function: () {
                        if (mobile.text.isEmpty) {
                          AppHelper().addmobile();
                          return;
                        }
                        print(mobile.text);
                        //  return;
                        controller.CheckIfExist(mobile.text.trim().toString());
                      },
                      width: Get.width * 0.9),
              button(
                  color: Colors.white,
                  title: 'dnthaveacc'.tr,
                  fontsize: 15,
                  fontColor: AppColors.color1,
                  borderColor: AppColors.color1,
                  height: 40,
                  function: () {
                    Get.to(() => Register());
                  },
                  width: Get.width * 0.9),
              button(
                  color: Colors.white,
                  title: 'guest'.tr,
                  fontsize: 15,
                  fontColor: AppColors.color1,
                  borderColor: AppColors.color1,
                  height: 40,
                  function: () {
                    controller.signIn(
                        emailAddress: 'guest@guest.com', password: '123123122');
                  },
                  width: Get.width * 0.9),
            ],
          ),
        ),
      ),
    );
  }
}
