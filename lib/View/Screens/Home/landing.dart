// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, camel_case_types

import 'package:flutter/Material.dart';
import 'package:get/get.dart';
import 'package:superconnect/Controller/HomeController.dart';

import '../../Widgets/RequestFromYouWidget.dart';
import '../../Widgets/RequestsToYouWidget.dart';

class landing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        init: HomeController(),
        builder: (controller) => Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    'ordertome'.tr,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                controller.info == null
                    ? CircularProgressIndicator()
                    : controller.info!.request!
                            .where((element) =>
                                element.reciverId == controller.user)
                            .toList()
                            .isEmpty
                        ? Center(
                            child: Text(
                              'There is no orders'.tr,
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : RequestsToYouWidget(),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    'myorder'.tr,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                controller.info == null
                    ? CircularProgressIndicator()
                    : controller.info!.request!
                            .where((element) =>
                                element.senderId == controller.user)
                            .toList()
                            .isEmpty
                        ? Center(
                            child: Text(
                              'There is no orders'.tr,
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : RequestFromYouWidget(),
              ],
            ));
  }
}
