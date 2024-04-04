// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:superconnect/Controller/HomeController.dart';
import 'package:superconnect/Controller/RequestsController.dart';
import 'package:superconnect/Utils/Colors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:superconnect/View/Screens/requests.dart/MyRequestPreview.dart';

import '../../Utils/Images.dart';

class RequestFromYouWidget extends StatelessWidget {
  final CarouselController controllerr = CarouselController();
  RequestsController requestController = Get.put(RequestsController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) => CarouselSlider.builder(
        itemCount: controller.requestsFromyou.length,
        itemBuilder: (context, index, realIndex) => Container(
          child: InkWell(
            onTap: () {
              requestController.itemsList?.clear();
              requestController.update();
              Get.to(() => MyRequestPreview(
                    request: controller.requestsFromyou[index],
                  ));
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10),
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
                                                .requestsFromyou[index]
                                                .reciverId
                                                .toString())]
                                        .image ==
                                    null
                                ? controller
                                            .familyList[
                                                controller.getPersonData(
                                                    userId: controller
                                                        .requestsFromyou[index]
                                                        .reciverId
                                                        .toString())]
                                            .gender ==
                                        0
                                    ? Container(
                                        height: 250,
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
                                        //  borderRadius: BorderRadius.circular(50),
                                        child: Image.network(
                                      controller
                                          .familyList[controller.getPersonData(
                                              userId: controller
                                                  .requestsFromyou[index]
                                                  .reciverId
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
                      controller.requestsFromyou[index].status == 0
                          ? _widget(iconcolor: Colors.red, title: 'reject'.tr)
                          : controller.requestsFromyou[index].status == 1
                              ? _widget(
                                  iconcolor: Colors.green, title: 'done'.tr)
                              : controller.requestsFromyou[index].status == 3
                                  ? _widget(
                                      iconcolor: Colors.yellow,
                                      title: 'acceptt'.tr)
                                  : _widget(
                                      iconcolor: Colors.blue,
                                      title: 'pending'.tr),
                      InkWell(
                          onTap: () {
                            requestController.addrequest(
                                request: controller.requestsFromyou[index]);
                          },
                          child: Column(
                            children: [
                              Icon(Icons.restart_alt_outlined),
                              Container(
                                  constraints: BoxConstraints(maxWidth: 50),
                                  child: Text(
                                    'again'.tr,
                                    style: TextStyle(),
                                    textAlign: TextAlign.center,
                                  ))
                            ],
                          )),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            controller
                                .familyList[controller.getPersonData(
                                    userId: controller
                                        .requestsFromyou[index].reciverId)]
                                .name!,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.color1),
                          ),
                          Text(
                            DateFormat.yMMMd().format(
                                DateFormat("yyyy-MM-dd hh:mm:ss").parse(
                                    controller
                                        .requestsFromyou[index].createdDate
                                        .toString())),
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey),
                          ),
                          Text(
                            DateFormat.jm().format(
                                DateFormat("yyyy-MM-dd hh:mm:ss").parse(
                                    controller
                                        .requestsFromyou[index].createdDate
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
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     Text(
            //       '{getdate(controller.)}',
            //       style: TextStyle(
            //           color: Colors.grey.shade700,
            //           fontWeight: FontWeight.bold,
            //           fontSize: 16),
            //     ),
            //     Text(
            //       '{getlenght(controller.',
            //       style: TextStyle(
            //           color: Colors.grey.shade700,
            //           fontWeight: FontWeight.bold,
            //           fontSize: 16),
            //     )
            //    ],
            // )
            //],
            // ),
          ),
        ),
        options: CarouselOptions(
            onPageChanged: (index, reason) {
              print(index);
            },
            enableInfiniteScroll: false,
            enlargeCenterPage: true,
            height: 430),
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
      SizedBox(
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
