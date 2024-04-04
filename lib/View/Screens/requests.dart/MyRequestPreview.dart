// ignore_for_file: must_be_immutable, prefer_const_constructors, avoid_unnecessary_containers, unused_element, non_constant_identifier_names, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:superconnect/Controller/RequestsController.dart';
import 'package:superconnect/Model/UserModel.dart';
import 'package:superconnect/Utils/Colors.dart';
import 'package:superconnect/View/Widgets/AppBar.dart';

class MyRequestPreview extends StatelessWidget {
  Request? request;

  MyRequestPreview({
    required this.request,
  }) {
    _alert();
  }
  _alert() {
    Future.delayed(Duration(milliseconds: 3)).then((value) {
      if (request!.status == 0)
        Get.defaultDialog(
            title: '',
            content: Container(
              child: Text(request!.note.toString()),
            ));
    });
  }

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
                      title: '',
                      color: Colors.white),
                  SizedBox(
                    height: 130,
                    child: controller.loading!
                        ? LinearProgressIndicator()
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller
                                .familyList[controller.getPersonById(
                                    userId: request?.reciverId)]
                                .categories
                                ?.length,
                            itemBuilder: (context, index) => InkWell(
                                onTap: () {
                                  // print(request?.items
                                  //     ?.where((element) =>
                                  //         element.cat ==
                                  //         controller.info!.categories![index])
                                  //     .toList()
                                  //     .map((e) => e)
                                  //     .toList()
                                  //     .toString());

                                  controller.itemsList = request?.items
                                      ?.where((element) =>
                                          element.cat['name'] ==
                                          controller
                                              .familyList[
                                                  controller.getPersonById(
                                                      userId:
                                                          request?.reciverId)]
                                              .categories![index]['name'])
                                      .toList()
                                      .map((e) => e)
                                      .toList();
                                  controller.update();
                                },
                                child: request!.items!
                                        .where((element) =>
                                            element.cat['name'] ==
                                            controller
                                                .familyList[
                                                    controller.getPersonById(
                                                        userId:
                                                            request?.reciverId)]
                                                .categories![index]['name'])
                                        .toList()
                                        .isEmpty
                                    ? Container()
                                    : _widget(
                                        controller: controller,
                                        categoryname: controller
                                            .familyList[
                                                controller.getPersonById(
                                                    userId: request?.reciverId)]
                                            .categories![index])),
                          ),
                  ),
                  Expanded(
                    child: AnimatedOpacity(
                        alwaysIncludeSemantics: true,
                        // If the widget is visible, animate to 0.0 (invisible).
                        // If the widget is hidden, animate to 1.0 (fully visible).
                        opacity: controller.itemsList!.isNotEmpty ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 1200),
                        // The green box must be a child of the AnimatedOpacity widget.

                        child: _Listview(
                            list: controller.itemsList!,
                            controller: controller)),
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
  return Container(
    padding: EdgeInsets.all(10),
    margin: EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    child: ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) => ItemWidget(
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
