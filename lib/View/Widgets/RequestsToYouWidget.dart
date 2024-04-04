// ignore_for_file: unused_import, use_key_in_widget_constructors, avoid_unnecessary_containers, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:superconnect/Controller/HomeController.dart';
import 'package:superconnect/Controller/RequestsController.dart';
import 'package:superconnect/Model/UserModel.dart';
import 'package:superconnect/Utils/Colors.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../Services/ApiServices.dart';
import '../../Utils/Images.dart';
import '../Screens/requests.dart/RequestsPreview.dart';
import 'Button.dart';
import 'TextField.dart';

class RequestsToYouWidget extends StatelessWidget {
  final CarouselController controllerr = CarouselController();
  RequestsController req_controller = Get.put(RequestsController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) => CarouselSlider.builder(
        itemCount: controller.requestsToyou.length,
        itemBuilder: (context, index, realIndex) => Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: InkWell(
            onTap: () {
              req_controller.itemsList?.clear();
              req_controller.update();
              Get.to(() => RequestPreview(
                    request: controller.requestsToyou[index],
                    requestId:
                        int.tryParse(controller.requestsToyou[index].id!),
                  ));
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25), color: Colors.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.all(5.0),
                    child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15.0)),
                        child: Stack(
                          children: <Widget>[
                            controller
                                        .familyList[controller.getPersonData(
                                            userId: controller
                                                .requestsToyou[index].senderId
                                                .toString())]
                                        .image ==
                                    null
                                ? controller
                                            .familyList[
                                                controller.getPersonData(
                                                    userId: controller
                                                        .requestsToyou[index]
                                                        .senderId
                                                        .toString())]
                                            .gender ==
                                        0
                                    ? Container(
                                        child: ClipRRect(
                                          // borderRadius:
                                          //     BorderRadius.circular(50),
                                          child: Image.asset(
                                            AppImages.male,
                                            height: 250,
                                            width: Get.width,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    : ClipRRect(
                                        //  borderRadius: BorderRadius.circular(50),
                                        child: Image.asset(
                                        AppImages.female,
                                        height: 250,
                                        width: Get.width,
                                        fit: BoxFit.cover,
                                      ))
                                : Container(
                                    height: 220,
                                    width: Get.width,
                                    margin: const EdgeInsets.all(10),
                                    child: ClipRRect(
                                        //    borderRadius: BorderRadius.circular(50),
                                        child: Image.network(
                                      controller
                                          .familyList[controller.getPersonData(
                                              userId: controller
                                                  .requestsToyou[index].senderId
                                                  .toString())]
                                          .image!,
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.cover,
                                    ))),
                            Positioned(
                              bottom: 0.0,
                              left: 0.0,
                              right: 0.0,
                              child: Container(
                                decoration: const BoxDecoration(
                                    // gradient: LinearGradient(
                                    //   colors: [Colors.white, Colors.white],
                                    //   begin: Alignment.bottomCenter,
                                    //   end: Alignment.topCenter,
                                    // ),
                                    ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                                child: Text(
                                  controller.selectedindex.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _options(
                              requestsController: req_controller,
                              controller: controller,
                              requesmodel: controller.requestsToyou[index]),
                          controller.requestsToyou[index].status == 0
                              ? _widget(
                                  iconcolor: Colors.red, title: 'reject'.tr)
                              : controller.requestsToyou[index].status == 1
                                  ? _widget(
                                      iconcolor: Colors.green, title: 'done'.tr)
                                  : controller.requestsToyou[index].status == 3
                                      ? _widget(
                                          iconcolor: Colors.yellow,
                                          title: 'acceptt'.tr)
                                      : _widget(
                                          iconcolor: Colors.blue,
                                          title: 'pending'.tr),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            controller
                                .familyList[controller.getPersonData(
                                    userId: controller
                                        .requestsToyou[index].senderId)]
                                .name!,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.color1),
                          ),
                          Text(
                            DateFormat.yMMMd().format(
                                DateFormat("yyyy-MM-dd hh:mm:ss").parse(
                                    controller.requestsToyou[index].createdDate
                                        .toString())),
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey),
                          ),
                          Text(
                            DateFormat.jm().format(
                                DateFormat("yyyy-MM-dd hh:mm:ss").parse(
                                    controller.requestsToyou[index].createdDate
                                        .toString())),
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        options: CarouselOptions(
            onPageChanged: (index, reason) {
              print(index);
            },
            enableInfiniteScroll: false,
            enlargeCenterPage: true,
            height: 410),
        carouselController: controllerr,
      ),
    );
  }
}

Widget _widget({required Color iconcolor, required String title}) {
  return Row(
    children: [
      Icon(
        Icons.circle,
        color: iconcolor,
      ),
      const SizedBox(
        width: 5,
      ),
      Text(
        title,
        style: TextStyle(
            color: iconcolor, fontSize: 15, fontWeight: FontWeight.bold),
      ),
    ],
  );
}

Widget _options(
    {required RequestsController requestsController,
    required HomeController controller,
    required Request requesmodel}) {
  return PopupMenuButton(
      // add icon, by default "3 dot" icon
      // icon: Icon(Icons.book)
      itemBuilder: (context) {
    return [
      PopupMenuItem<int>(
        value: 0,
        child: Text("accept".tr),
      ),
      PopupMenuItem<int>(
        value: 1,
        child: Text("refuse".tr),
      ),
      PopupMenuItem<int>(
        value: 2,
        child: Text("acceptt".tr),
      ),
    ];
  }, onSelected: (value) {
    if (value == 0) {
      controller.updateRequestStatus(request: requesmodel, stat: 1);
      ApiServices().sendNotification(
          body:
              'لقد قام${controller.info?.name.toString()} بالانتهاء من المهمه',
          title: controller.info?.name,
          token: controller
              .familyList[controller.familyList
                  .indexWhere((element) => element.id == requesmodel.senderId)]
              .token);
    } else if (value == 1) {
      _alert(
          requestsController: requestsController,
          controller: controller,
          requesmodel: requesmodel);
    } else if (value == 2) {
      controller.updateRequestStatus(request: requesmodel, stat: 3);
      ApiServices().sendNotification(
          body: 'جاري تنفيذ المهمه',
          title: controller.info?.name,
          token: controller
              .familyList[controller.familyList
                  .indexWhere((element) => element.id == requesmodel.senderId)]
              .token);
    }
  });
}

_alert(
    {required RequestsController requestsController,
    required HomeController controller,
    required Request requesmodel}) {
  var note = TextEditingController();
  Get.defaultDialog(
      content: Column(
    children: [
      TextFieldWidget(
          controller: note,
          title: 'note'.tr,
          enable: true,
          iconData: Icons.abc,
          IsPass: false,
          width: Get.width * 0.6),
      button(
          color: AppColors.color1,
          title: 'continue'.tr,
          fontsize: 15,
          fontColor: Colors.white,
          height: 50,
          function: () {
            requesmodel.note = note.text.toString();
            controller.updateRequestStatus(
                request: requesmodel, stat: 0, note: note.text);
            ApiServices().sendNotification(
                body: '${note.text} يؤسفني رفض المهمه !',
                title: controller.info?.name,
                token: controller
                    .familyList[controller.familyList.indexWhere(
                        (element) => element.id == requesmodel.senderId)]
                    .token);
            Get.back();
          },
          width: 150),
    ],
  ));
}
