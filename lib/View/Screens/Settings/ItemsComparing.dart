// ignore_for_file: prefer_const_constructors, no_leading_underscores_for_local_identifiers, unused_element

import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:superconnect/Controller/SettingController.dart';
import 'package:superconnect/Model/ItemDataModel.dart';
import 'package:superconnect/Utils/Colors.dart';
import 'package:superconnect/Utils/Helper.dart';
import 'package:superconnect/Utils/Images.dart';
import 'package:superconnect/View/Widgets/AppBar.dart';
import 'package:superconnect/View/Widgets/Button.dart';

class ItemsComparing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(
      init: SettingController(),
      builder: (controller) => Scaffold(
        backgroundColor: Colors.white,
        body: controller.itemcomparingLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.color1,
                  backgroundColor: Colors.grey,
                ),
              )
            : Column(
                children: [
                  App_Bar(
                      iconData: Icons.compare,
                      title: '',
                      color: AppColors.color1),
                  SizedBox(
                    height: 30,
                  ),
                  _widget(controller: controller),
                  Expanded(
                      child: ListView.builder(
                    physics: ScrollPhysics(),
                    itemCount: controller.itemsComparingList.length,
                    itemBuilder: (context, index) => Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(color: Colors.grey, blurRadius: 2)
                              ]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      AppImages.item,
                                      height: 50,
                                      width: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    controller
                                        .itemsComparingList[index].proudactName
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.color1),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      _confirm(
                                          index: index, controller: controller);

                                      // controller.deletFromComparingList(
                                      //     model: controller
                                      //         .itemsComparingList[index]);
                                    },
                                    child: Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.grey,
                                        )),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      _addStoreToItemDialog(
                                          isEdit: false,
                                          controller: controller,
                                          index: index);
                                    },
                                    child: Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.grey,
                                        )),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: ((controller.itemsComparingList[index].data
                                      ?.length)! *
                                  50) +
                              50,
                          child: ExpandChild(
                            child: SizedBox(
                              height: (controller.itemsComparingList[index].data
                                      ?.length)! *
                                  50,
                              child: ListView.builder(
                                itemCount: controller
                                    .itemsComparingList[index].data?.length,
                                itemBuilder: (context, index2) => Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            constraints: BoxConstraints(
                                                maxWidth: Get.width * 0.5),
                                            child: Text(
                                              controller
                                                  .itemsComparingList[index]
                                                  .data![index2]
                                                  .store
                                                  .toString(),
                                              style: TextStyle(
                                                  color: AppColors.color1,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                controller
                                                    .itemsComparingList[index]
                                                    .data![index2]
                                                    .price
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  _addStoreToItemDialog(
                                                      isEdit: true,
                                                      index2: index2,
                                                      controller: controller,
                                                      index: index);
                                                },
                                                child: Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5),
                                                    child: Icon(
                                                      Icons.edit,
                                                      color: Colors.grey,
                                                    )),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Divider(
                                        thickness: 1.5,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ))
                ],
              ),
      ),
    );
  }
}

Widget _widget({required SettingController controller}) {
  var _ct = TextEditingController();
  return InkWell(
    onTap: () {
      if (_ct.text.isEmpty) {
        AppHelper.errorsnackbar('ec'.tr);
        return;
      }
      controller.addToComparingList(
          model: ItemDataModel(
        proudactName: _ct.text.toString(),
        data: [],
      ));
    },
    child: Container(
      color: AppColors.color1,
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 250,
                  height: 30,
                  child: TextFormField(
                    controller: _ct,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        label: Text(
                          'itemname'.tr,
                          style: TextStyle(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.white)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.white))),
                  ),
                ),
                Text(
                  'add'.tr,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

_addStoreToItemDialog(
    {required bool isEdit,
    required SettingController controller,
    required index,
    int? index2}) {
  var _ctName = TextEditingController();
  var _ctPrice = TextEditingController();
  if (isEdit) {
    _ctName.text =
        controller.itemsComparingList[index].data![index2!].store.toString();
    _ctPrice.text =
        controller.itemsComparingList[index].data![index2].price.toString();
  }
  return Get.defaultDialog(
      backgroundColor: AppColors.color1,
      title: '',
      content: Column(
        children: [
          SizedBox(
            width: 250,
            height: 30,
            child: TextFormField(
              controller: _ctName,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  label: Text(
                    'storname'.tr,
                    style: TextStyle(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white))),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 250,
            height: 30,
            child: TextFormField(
              controller: _ctPrice,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  label: Text(
                    'price'.tr,
                    style: TextStyle(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white))),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          button(
              color: Colors.white,
              title: 'continue'.tr,
              fontsize: 15,
              fontColor: AppColors.color1,
              height: 35,
              function: () {
                if (_ctName.text.isEmpty || _ctPrice.text.isEmpty) {
                  return;
                }
                if (isEdit) {
                  controller.itemsComparingList[index].data?[index2!] =
                      Data(store: _ctName.text, price: _ctPrice.text);
                  controller.editFromComparingList(
                      model: controller.itemsComparingList[index]);
                  return;
                }
                controller.itemsComparingList[index].data
                    ?.add(Data(store: _ctName.text, price: _ctPrice.text));
                controller.editFromComparingList(
                    model: controller.itemsComparingList[index]);
              },
              border: 10,
              width: 250),
          if (isEdit)
            button(
                color: Colors.red,
                title: 'delete'.tr,
                fontsize: 15,
                fontColor: Colors.white,
                height: 35,
                function: () {
                  controller.itemsComparingList[index].data?.removeAt(index2!);

                  controller.editFromComparingList(
                      model: controller.itemsComparingList[index]);
                },
                border: 10,
                width: 250)
        ],
      ));
}

_confirm({required index, required SettingController controller}) {
  Get.defaultDialog(
      title: 'areyousure'.tr,
      content: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              AppImages.logo,
              height: 250,
              width: Get.width,
              fit: BoxFit.cover,
            ),
          ),
          button(
              color: AppColors.color1,
              title: 'Continue'.tr,
              fontsize: 15,
              fontColor: Colors.white,
              height: 40,
              function: () {
                Get.back();

                controller.delete_item(index);
                Get.back();

                //   controller.deletFromComparingList(index: index);
              },
              width: Get.width * 0.6),
          button(
              color: Colors.red,
              title: 'back'.tr,
              fontsize: 15,
              fontColor: Colors.white,
              height: 40,
              function: () {
                Get.back();
              },
              width: Get.width * 0.6),
        ],
      ));
}
