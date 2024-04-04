import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:superconnect/Controller/HomeController.dart';

class MainContainer extends StatelessWidget {
  const MainContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) => Scaffold(
        body: controller.widget,
      ),
    );
  }
}
