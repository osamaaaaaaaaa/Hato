// ignore_for_file: must_be_immutable, prefer_const_constructors, avoid_unnecessary_containers, unused_element, non_constant_identifier_names, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:superconnect/Controller/RequestsController.dart';
import 'package:superconnect/Model/UserModel.dart';
import 'package:superconnect/Utils/Colors.dart';
import 'package:superconnect/Utils/Helper.dart';
import 'package:superconnect/View/Widgets/AppBar.dart';
import 'package:superconnect/View/Widgets/Button.dart';

import '../../Widgets/Person.dart';
import '../../Widgets/TextField.dart';

class AddNewRequest extends StatelessWidget {
  String? ReciverId;
  bool? isEdit, isNew;
  AddNewRequest(
      {required this.ReciverId, required this.isEdit, required this.isNew});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RequestsController>(
      init: RequestsController(),
      builder: (controller) => Scaffold(
        backgroundColor: AppColors.color1,
        body: controller.info == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  App_Bar(
                      iconData: Icons.border_outer_rounded,
                      title: controller.NewRequestCategoryName.toString(),
                      color: Colors.white),
                  SizedBox(
                    height: 130,
                    child: controller.loading!
                        ? CircularProgressIndicator()
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.info?.categories?.length,
                            itemBuilder: (context, index) => index == 0
                                ? Container()
                                : InkWell(
                                    onTap: () {
                                      controller.NewRequestCategoryName =
                                          controller
                                              .info?.categories?[index]['name']
                                              .toString();
                                      controller.NewRequestCategoryImage =
                                          controller
                                              .info?.categories?[index]['image']
                                              .toString();
                                      controller.update();
                                      print(
                                          controller.NewRequestModel?.toJson());
                                    },
                                    child: _widget(
                                        controller: controller,
                                        categoryname: controller
                                            .info!.categories![index])),
                          ),
                  ),
                  Expanded(
                    child: AnimatedOpacity(
                        alwaysIncludeSemantics: true,
                        // If the widget is visible, animate to 0.0 (invisible).
                        // If the widget is hidden, animate to 1.0 (fully visible).
                        opacity: controller.NewRequestCategoryName == null
                            ? 0.0
                            : 1.0,
                        duration: const Duration(milliseconds: 1200),
                        // The green box must be a child of the AnimatedOpacity widget.

                        child: _Listview(
                            list: controller.NewRequestModel!.items!
                                .where((element) =>
                                    element.cat['name'] ==
                                    controller.NewRequestCategoryName)
                                .toList(),
                            controller: controller)),
                  ),
                  !isNew!
                      ? Column(
                          children: [
                            button(
                              borderColor: Colors.white,
                              color: AppColors.color1,
                              title: 'send'.tr,
                              fontsize: 16,
                              fontColor: Colors.white,
                              height: 40,
                              width: Get.width,
                              function: () {
                                if (controller
                                    .NewRequestModel!.items!.isEmpty) {
                                  AppHelper.errorsnackbar('error');
                                  return;
                                }
                                controller.NewRequestModel?.reciverId =
                                    ReciverId;
                                controller.NewRequestModel?.senderId =
                                    controller.user;
                                isEdit!
                                    ? PersonsAlertWidget(
                                        controller: controller,
                                      )
                                    : controller.addrequest(
                                        request: controller.NewRequestModel!);
                              },
                            ),
                            button(
                              color: Colors.white,
                              borderColor: AppColors.color1,
                              title: 'saveasdraft'.tr,
                              fontsize: 16,
                              fontColor: AppColors.color1,
                              height: 40,
                              width: Get.width,
                              function: () {
                                if (controller
                                    .NewRequestModel!.items!.isEmpty) {
                                  AppHelper.errorsnackbar('error');
                                  return;
                                }
                                controller.NewRequestModel?.reciverId =
                                    controller.user;
                                controller.NewRequestModel?.senderId =
                                    controller.user;
                                isEdit!
                                    ? controller.editDraft(
                                        request: controller.NewRequestModel!)
                                    : _alert(
                                        requestsController: controller,
                                        requesmodel:
                                            controller.NewRequestModel!);
                                //controller.adddraft(request: controller.NewRequestModel!);
                              },
                            ),
                          ],
                        )
                      :

                      //in case draft

                      Column(
                          children: [
                            button(
                              borderColor: Colors.white,
                              color: AppColors.color1,
                              title: 'send'.tr,
                              fontsize: 16,
                              fontColor: Colors.white,
                              height: 40,
                              width: Get.width,
                              function: () {
                                if (controller
                                    .NewRequestModel!.items!.isEmpty) {
                                  AppHelper.errorsnackbar('error');
                                  return;
                                }
                                controller.NewRequestModel?.reciverId =
                                    ReciverId;
                                controller.NewRequestModel?.senderId =
                                    controller.user;
                                PersonsAlertWidget(
                                  controller: controller,
                                );
                              },
                            ),
                            button(
                              color: Colors.white,
                              borderColor: AppColors.color1,
                              title: 'saveasdraft'.tr,
                              fontsize: 16,
                              fontColor: AppColors.color1,
                              height: 40,
                              width: Get.width,
                              function: () {
                                if (controller
                                    .NewRequestModel!.items!.isEmpty) {
                                  AppHelper.errorsnackbar('error');
                                  return;
                                }
                                controller.NewRequestModel?.reciverId =
                                    controller.user;
                                controller.NewRequestModel?.senderId =
                                    controller.user;
                                _alert(
                                    requestsController: controller,
                                    requesmodel: controller.NewRequestModel!);
                                //controller.adddraft(request: controller.NewRequestModel!);
                              },
                            ),
                          ],
                        ),
                ],
              ),
      ),
    );
  }
}

Widget _widget(
    {required categoryname, required RequestsController controller}) {
  return Container(
    margin: EdgeInsets.all(10),
    child: Column(
      children: [
        categoryname['image'] != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  categoryname['image']!,
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                ),
              )
            : Container(
                alignment: Alignment.center,
                height: 80,
                width: 80,
                // padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.amber),
                child: Text(
                    '${categoryname['name'][0]}${categoryname[categoryname['name'].toString().length - 1]}',
                    style: TextStyle(
                        color: AppColors.color1,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ),
        Text(
          categoryname['name'],
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
        )
      ],
    ),
  );
}

Widget _Listview({
  required List<Items> list,
  required RequestsController controller,
}) {
  var name = TextEditingController();
  var note = TextEditingController();
  return Container(
    padding: EdgeInsets.all(10),
    margin: EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    child: ListView.builder(
      itemCount: list.length + 1,
      itemBuilder: (context, index) => index == list.length
          ? Column(
              children: [
                Container(
                    width: Get.width * 0.8,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: TextFormField(
                      controller: name,
                      decoration: InputDecoration(
                          label: Text('ordername'.tr),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    )),
                Container(
                    width: Get.width * 0.8,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: TextFormField(
                      controller: note,
                      decoration: InputDecoration(
                          label: Text('note'.tr),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    )),
                button(
                    color: AppColors.color1,
                    title: 'add'.tr,
                    fontsize: 16,
                    fontColor: Colors.white,
                    height: 40,
                    icon: Icons.add,
                    function: () {
                      controller.NewRequestModel?.items?.add(Items(
                          name: name.text,
                          notes: note.text,
                          status: 2,
                          cat: {
                            "name": controller.NewRequestCategoryName,
                            "image": controller.NewRequestCategoryName,
                          }));
                      controller.update();
                    },
                    width: Get.width * 0.8),
              ],
            )
          : ItemWidget(
              item: list[index],
              controller: controller,
              index: index,
            ),
    ),
  );
}

Widget ItemWidget(
    {required Items item,
    required RequestsController controller,
    required int index}) {
  return Container(
    margin: EdgeInsets.all(10),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Text(
              //   (index + 1).toString(),
              //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              // ),
              // SizedBox(
              //   width: 10,
              // ),
              Container(
                width: Get.width - 85,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      constraints: BoxConstraints(maxWidth: Get.width - 180),
                      child: Text(
                        item.name.toString(),
                        style: TextStyle(
                            decoration: item.status == 1
                                ? TextDecoration.lineThrough
                                : item.status == 0
                                    ? TextDecoration.lineThrough
                                    : null,
                            color: item.status == 1
                                ? Colors.green
                                : item.status == 0
                                    ? Colors.red
                                    : AppColors.color1,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          controller.NewRequestModel?.items?.remove(item);
                          controller.update();
                        },
                        child: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ))
                  ],
                ),
              ),
            ],
          ),
          // options(
          //     controller: controller, index: index, requestIndex: requestIndex)
        ],
      ),
      Container(
        child: Text(
          item.notes.toString(),
          style: TextStyle(color: Colors.grey),
        ),
      ),
      Divider(
        color: Colors.grey,
        thickness: 1,
      )
    ]),
  );
}

Widget options(
    {required RequestsController controller,
    required int index,
    required int requestIndex}) {
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
    ];
  }, onSelected: (value) {
    if (value == 0) {
      controller.itemsList?[index].status = 1;
      controller.update();
      controller.updateuser(requestIndex);
    } else if (value == 1) {
      controller.itemsList?[index].status = 0;
      controller.update();
      controller.updateuser(requestIndex);
    } else if (value == 2) {
      print("Logout menu is selected.");
    }
  });
}

_alert(
    {required RequestsController requestsController,
    required Request requesmodel}) {
  var note = TextEditingController();
  Get.defaultDialog(
      content: Column(
    children: [
      TextFieldWidget(
          controller: note,
          title: 'name'.tr,
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
            if (note.text.isEmpty) {
              return;
            }
            requesmodel.note = note.text;

            requestsController.adddraft(request: requesmodel);
          },
          width: 150),
    ],
  ));
}

PersonsAlertWidget({
  required RequestsController controller,
}) {
  return Get.defaultDialog(
    title: '',
    content: SizedBox(
        height: 120,
        width: Get.width - 100,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.familyList.length,
            itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    controller.NewRequestModel?.reciverId =
                        controller.familyList[index].id;
                    controller.addrequest(request: controller.NewRequestModel!);
                  },
                  child: Person(
                      name: controller.familyList[index].name.toString(),
                      image: controller.familyList[index].image,
                      gender: controller.familyList[index].gender),
                ))),
  );
}
