// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:superconnect/Controller/AuthController.dart';
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
                  ignoreBlank: false,
                  autoValidateMode: AutovalidateMode.disabled,
                  selectorTextStyle: TextStyle(color: Colors.black),
                  formatInput: true,
                  keyboardType: TextInputType.numberWithOptions(
                      signed: true, decimal: true),
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
                      title: 'continue'.tr,
                      fontsize: 15,
                      fontColor: Colors.white,
                      height: 40,
                      function: () {
                        controller.CheckIfExist(mobile.text.trim().toString());
                        //  controller.phoneSignIn(phoneNumber: mobile.text);
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
                    Get.to(() => guest());
                  },
                  width: Get.width * 0.9),
            ],
          ),
        ),
      ),
    );
  }
}
