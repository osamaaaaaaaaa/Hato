// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:superconnect/Controller/AuthController.dart';
import 'package:superconnect/Model/UserModel.dart';
import 'package:superconnect/Utils/Helper.dart';
import 'package:superconnect/Utils/Images.dart';
import 'package:superconnect/View/Widgets/TextField.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../Utils/Colors.dart';
import '../../Widgets/Button.dart';

class Register extends StatelessWidget {
  var email = TextEditingController();
  var pass = TextEditingController();
  var mobile = TextEditingController();
  var username = TextEditingController();

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
                  controller: username,
                  title: 'username'.tr,
                  enable: true,
                  iconData: Icons.abc,
                  IsPass: false,
                  width: Get.width * 0.9),
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
                height: 20,
              ),
              // Gender(controller: controller),
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
                        if (username.text.isEmpty || mobile.text.isEmpty) {
                          return;
                        }
                        if (mobile.text.length < 5 ||
                            username.text.length < 3) {
                          AppHelper.errorsnackbar('mobile'.tr);
                          return;
                        }
                        controller.model = UserModel(
                            name: username.text,
                            email: email.text.trim(),
                            pass: pass.text.trim(),
                            mobile: mobile.text.trim(),
                            categories: [
                              {
                                "name": "اختر",
                                "image":
                                    "https://firebasestorage.googleapis.com/v0/b/famcon-acdde.appspot.com/o/images%2F14478854_Cheese_isolated_cartoon_art_illustration.jpg?alt=media&token=65c42e3c-00eb-44a8-891f-4b4176f06445"
                              },
                              {
                                "name": "خضروات",
                                "image":
                                    "https://firebasestorage.googleapis.com/v0/b/famcon-acdde.appspot.com/o/images%2F14478854_Cheese_isolated_cartoon_art_illustration.jpg?alt=media&token=65c42e3c-00eb-44a8-891f-4b4176f06445"
                              },
                              {
                                "name": "فاكهه",
                                "image":
                                    "https://firebasestorage.googleapis.com/v0/b/famcon-acdde.appspot.com/o/images%2F14478854_Cheese_isolated_cartoon_art_illustration.jpg?alt=media&token=65c42e3c-00eb-44a8-891f-4b4176f06445"
                              },
                              {
                                "name": "منظفات",
                                "image":
                                    "https://firebasestorage.googleapis.com/v0/b/famcon-acdde.appspot.com/o/images%2F14478854_Cheese_isolated_cartoon_art_illustration.jpg?alt=media&token=65c42e3c-00eb-44a8-891f-4b4176f06445"
                              },
                              {
                                "name": "بقاله",
                                "image":
                                    "https://firebasestorage.googleapis.com/v0/b/famcon-acdde.appspot.com/o/images%2F14478854_Cheese_isolated_cartoon_art_illustration.jpg?alt=media&token=65c42e3c-00eb-44a8-891f-4b4176f06445"
                              },
                              {
                                "name": "لحوم",
                                "image":
                                    "https://firebasestorage.googleapis.com/v0/b/famcon-acdde.appspot.com/o/images%2F14478854_Cheese_isolated_cartoon_art_illustration.jpg?alt=media&token=65c42e3c-00eb-44a8-891f-4b4176f06445"
                              },
                            ],
                            family: [],
                            request: [],
                            idNo:
                                '${username.text[0]}${username.text[1]}${username.text[2]}${mobile.text[3]}${mobile.text[2]}${mobile.text[5]}');

                        controller.phoneSignIn(phoneNumber: mobile.text);
                      },
                      width: Get.width * 0.9),
              const SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget Gender({required AuthController controller}) => Column(
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
