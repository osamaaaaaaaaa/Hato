import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:superconnect/Controller/guestController.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class contact_us extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<guestController>(
      init: guestController(),
      builder: (controller) => Scaffold(
        body: SingleChildScrollView(
            child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                    onTap: () {
                      UrlLauncher.launch(
                          'mailto:${controller.contactMap!['email']}');
                    },
                    child: Icon(
                      Icons.mail,
                      color: Colors.red,
                      size: 40,
                    )),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                    onTap: () {
                      UrlLauncher.launch(
                          'tel://${controller.contactMap!['mobile']}');
                    },
                    child: Icon(
                      Icons.call,
                      color: Colors.green,
                      size: 40,
                    )),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                    onTap: () {
                      UrlLauncher.launch(
                          '${controller.contactMap!['facebook']}');
                    },
                    child: Icon(
                      Icons.facebook,
                      color: Color.fromARGB(255, 3, 83, 148),
                      size: 40,
                    )),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                    onTap: () {
                      UrlLauncher.launch(
                          '${controller.contactMap!['snapchat']}');
                    },
                    child: Icon(
                      Icons.snapchat_outlined,
                      color: Color.fromARGB(255, 188, 172, 34),
                      size: 40,
                    )),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
