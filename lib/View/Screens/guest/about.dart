import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:get/get.dart';
import 'package:superconnect/Controller/guestController.dart';

class about extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<guestController>(
      init: guestController(),
      builder: (controller) => Scaffold(
        body: SingleChildScrollView(
            child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: Text(
                '''${controller.about}''',
                style: TextStyle(fontSize: 17),
              ),
            )
          ],
        )),
      ),
    );
  }
}
