// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

import '../../Utils/Colors.dart';

Widget TextFieldWidget(
        {required TextEditingController controller,
        required String title,
        required bool enable,
        required IconData? iconData,
        required bool IsPass,
        required double width}) =>
    Container(
      height: 50,
      width: width,
      margin: const EdgeInsets.only(top: 10, bottom: 10, right: 15, left: 15),
      child: TextFormField(
        enabled: enable,
        controller: controller,
        obscureText: IsPass,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          prefixIcon: Icon(
            iconData,
            //   color: AppColors.gold,
          ),
          label: Text(title, style: const TextStyle(color: Colors.grey)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: AppColors.color1,
              width: 2.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: AppColors.color1,
              width: 2.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: AppColors.color1,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
