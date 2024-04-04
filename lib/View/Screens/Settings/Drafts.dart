// ignore_for_file: file_names, non_constant_identifier_names, must_be_immutable
// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/Material.dart';
import 'package:get/get.dart';
import 'package:superconnect/View/Screens/requests.dart/AddNewRequest.dart';

import '../../../Controller/RequestsController.dart';
import '../../../Model/UserModel.dart';
import '../../../Utils/Colors.dart';
import '../../../Utils/Images.dart';
import '../../Widgets/Button.dart';

class Drafts extends StatelessWidget {
  RequestsController req_controller = Get.put(RequestsController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RequestsController>(
      init: RequestsController(),
      builder: (controller) => Scaffold(
        body: _Requests(
          title: '',
          controller: req_controller,
          list: controller.drafts,
        ),
      ),
    );
  }
}

Widget _Requests({
  required title,
  required RequestsController controller,
  required List<Request>? list,
}) {
  return Container(
    height: Get.height,
    width: Get.width,
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20), color: Colors.white),
    child: Column(
      children: [
        SizedBox(
          height: Get.height * 0.8,
          child: ListView.builder(
            physics: const ScrollPhysics(),
            itemCount: list?.length,
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                // requestsController.itemsList?.clear();
                // requestsController.update();
                controller.NewRequestModel = controller.drafts[index];
                controller.update();
                Get.to(() => AddNewRequest(
                      ReciverId: '',
                      isNew: false,
                      isEdit: true,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              controller.info?.image == null
                                  ? controller.info!.gender == 0
                                      ? Container(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Image.asset(
                                              AppImages.male,
                                              height: 70,
                                            ),
                                          ),
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Image.asset(
                                            AppImages.female,
                                            height: 70,
                                          ))
                                  : Container(
                                      margin: const EdgeInsets.all(10),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Image.network(
                                            controller.info!.image!,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.drafts[index].note.toString(),
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.color1),
                            ),
                          ],
                        ),
                      ],
                    ),

                    ///////////////////////
                    ///
                  ],
                ),
              ),
            ),
          ),
        ),
        button(
          borderColor: Colors.white,
          color: AppColors.color1,
          title: 'add'.tr,
          fontsize: 16,
          fontColor: Colors.white,
          height: 40,
          width: Get.width,
          function: () {
            controller.NewRequestModel = Request(items: []);
            Get.to(() => AddNewRequest(
                  ReciverId: 'ReciverId',
                  isEdit: true,
                  isNew: true,
                ));
          },
        ),
      ],
    ),
  );
}

Widget _widget({required Color iconcolor, required String title}) {
  return Row(
    children: [
      Icon(
        Icons.circle,
        color: iconcolor,
      ),
      Text(
        title,
        style: TextStyle(
            color: iconcolor, fontSize: 15, fontWeight: FontWeight.bold),
      ),
    ],
  );
}
