// ignore_for_file: unnecessary_import, file_names, use_key_in_widget_constructors, non_constant_identifier_names, avoid_unnecessary_containers, must_be_immutable

import 'package:flutter/Material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:intl/intl.dart';

import '../../../Controller/HomeController.dart';
import '../../../Controller/RequestsController.dart';
import '../../../Model/UserModel.dart';
import '../../../Utils/Colors.dart';
import '../../../Utils/Images.dart';
import 'RequestsPreview.dart';

class RequestToYouList extends StatelessWidget {
  RequestsController req_controller = Get.put(RequestsController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) => _Requests(
          title: '', list: controller.requestsToyou, controller: controller),
    );
  }

  Widget _widget({required Color iconcolor, required String title}) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
              color: iconcolor, fontSize: 15, fontWeight: FontWeight.bold),
        ),
        Icon(
          Icons.circle,
          color: iconcolor,
        )
      ],
    );
  }

  Widget _Requests(
      {required title,
      required List<Request>? list,
      required HomeController controller}) {
    return Container(
      height: Get.height * 0.6,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white),
      child: controller.loading == true
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : list!.isEmpty
              ? Center(
                  child: Text('There is no orders'.tr),
                )
              : Column(
                  children: [
                    SizedBox(
                      height: Get.height * 0.5,
                      child: ListView.builder(
                        physics: const ScrollPhysics(),
                        itemCount: list.length,
                        itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            req_controller.itemsList?.clear();
                            req_controller.update();
                            Get.to(() => RequestPreview(
                                  request: controller.requestsToyou[index],
                                  requestId: int.tryParse(
                                      controller.requestsToyou[index].id!),
                                ));
                          },
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          controller
                                                      .familyList[controller
                                                          .getPersonData(
                                                              userId: list[
                                                                      index]
                                                                  .senderId
                                                                  .toString())]
                                                      .image ==
                                                  null
                                              ? controller
                                                          .familyList[controller
                                                              .getPersonData(
                                                                  userId: list[
                                                                          index]
                                                                      .senderId
                                                                      .toString())]
                                                          .gender ==
                                                      0
                                                  ? Container(
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        child: Image.asset(
                                                          AppImages.male,
                                                          height: 70,
                                                        ),
                                                      ),
                                                    )
                                                  : ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      child: Image.asset(
                                                        AppImages.female,
                                                        height: 70,
                                                      ))
                                              : Container(
                                                  margin:
                                                      const EdgeInsets.all(10),
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      child: Image.network(
                                                        controller
                                                            .familyList[controller
                                                                .getPersonData(
                                                                    userId: list[
                                                                            index]
                                                                        .senderId)]
                                                            .image!,
                                                        height: 80,
                                                        width: 80,
                                                        fit: BoxFit.cover,
                                                      ))),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          controller
                                              .familyList[
                                                  controller.getPersonData(
                                                      userId:
                                                          list[index].senderId)]
                                              .name!,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.color1),
                                        ),
                                        Text(
                                          DateFormat.yMMMd().format(
                                              DateFormat("yyyy-MM-dd hh:mm:ss")
                                                  .parse(list[index]
                                                      .createdDate
                                                      .toString())),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.grey),
                                        ),
                                        Text(
                                          DateFormat.jm().format(
                                              DateFormat("yyyy-MM-dd hh:mm:ss")
                                                  .parse(list[index]
                                                      .createdDate
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

                                ///////////////////////
                                ///

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    list[index].status == 0
                                        ? _widget(
                                            iconcolor: Colors.red,
                                            title: 'reject'.tr)
                                        : list[index].status == 1
                                            ? _widget(
                                                iconcolor: Colors.green,
                                                title: 'done'.tr)
                                            : controller.requestsToyou[index]
                                                        .status ==
                                                    3
                                                ? _widget(
                                                    iconcolor: Colors.yellow,
                                                    title: 'acceptt'.tr)
                                                : _widget(
                                                    iconcolor: Colors.blue,
                                                    title: 'pending'.tr),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                        onTap: () {
                                          controller.DeleteReq(
                                              request: controller
                                                  .requestsToyou[index]);
                                        },
                                        child: Icon(
                                          Icons.delete_forever,
                                          color: Colors.red,
                                        ))
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
