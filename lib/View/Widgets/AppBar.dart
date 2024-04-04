// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget App_Bar(
    {required IconData iconData, required title, required Color color}) {
  return Container(
    padding: EdgeInsets.only(top: 35),
    margin: EdgeInsets.all(10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: color,
          ),
        ),
        Text(
          '${title}',
          style: TextStyle(
              color: color, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Icon(
          iconData,
          color: color,
        ),
      ],
    ),
  );
}
