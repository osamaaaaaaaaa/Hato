// ignore_for_file: unused_field, sort_child_properties_last, no_trailing_underscores_for_local_identifiers, file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:superconnect/Controller/HomeController.dart';
import 'package:superconnect/Controller/RequestsController.dart';
import 'package:superconnect/Controller/SettingController.dart';
import 'package:superconnect/Utils/Colors.dart';
import 'package:superconnect/Utils/Helper.dart';
import 'package:superconnect/View/Screens/Settings/CategoriesMangment.dart';
import 'package:superconnect/View/Screens/Settings/Drafts.dart';
import 'package:superconnect/View/Screens/Settings/Profile.dart';
import 'package:superconnect/View/Screens/requests.dart/AddNewRequest.dart';
import 'package:superconnect/View/Widgets/Person.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import '../../Widgets/datebar.dart';
import '../Chat/Conversation.dart';
import '../Settings/ItemsComparing.dart';

class Home extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();

  toggleMenu([bool end = false]) {
    if (end) {
    } else {
      final _state = _sideMenuKey.currentState!;
      if (_state.isOpened) {
        _state.closeSideMenu();
      } else {
        _state.openSideMenu();
      }
    }
  }

  Home({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) => SideMenu(
        key: _sideMenuKey,
        inverse: true, // end side menu
        background: AppColors.color1,
        type: SideMenuType.slideNRotate,
        menu: Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child:
              buildMenu(context, controller.info?.name, controller.info?.idNo),
        ),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: controller.loading == true
              ? const Center(
                  child: LinearProgressIndicator(
                      color: AppColors.color1, backgroundColor: Colors.grey),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.all(10),
                        height: 190,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                toggleMenu();
                              },
                              child: DateBar(
                                  name: controller.info?.name.toString()),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 109,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (controller.guest) {
                                        AppHelper().shouldSignin();
                                        return;
                                      }
                                      controller.addNewFamilyMember();
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(5),
                                      child: Column(
                                        children: [
                                          const CircleAvatar(
                                            backgroundColor: AppColors.color1,
                                            foregroundColor: AppColors.color1,
                                            maxRadius: 32,
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                  ),
                                                ]),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            'addperson'.tr,
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height: 10,
                                      width: Get.width - 100,
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount:
                                              controller.familyList.length,
                                          itemBuilder: (context, index) =>
                                              InkWell(
                                                onTap: () {
                                                  Get.to(() => Conversation(
                                                        model: controller
                                                            .familyList[index],
                                                        ReciverId: controller
                                                            .familyList[index]
                                                            .id,
                                                        userId: controller.user,
                                                      ));
                                                },
                                                child: Person(
                                                    name: controller
                                                        .familyList[index].name
                                                        .toString(),
                                                    image: controller
                                                        .familyList[index]
                                                        .image,
                                                    gender: controller
                                                        .familyList[index]
                                                        .gender),
                                              ))),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Center(
                          child: InkWell(
                              onTap: () {
                                controller.getInfo();
                              },
                              child: Icon(Icons.restart_alt))),
                      SizedBox(height: 10),
                      Container(
                        constraints:
                            BoxConstraints(minHeight: Get.height - 240),
                        padding: EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: const BoxDecoration(
                            color: AppColors.color1,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(
                                  30,
                                ),
                                topRight: Radius.circular(30))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: Get.width,
                              alignment: Alignment.center,
                              height: 50,
                              child: ListView.builder(
                                itemExtent: 120,
                                scrollDirection: Axis.horizontal,
                                itemCount: controller.list.length,
                                itemBuilder: (context, index) => InkWell(
                                  onTap: () {
                                    controller.selectedindex = index;
                                    controller.update();
                                  },
                                  child: _widget(
                                      title: controller.list[index],
                                      index: index,
                                      fontColor:
                                          controller.selectedindex == index
                                              ? Colors.black
                                              : Colors.white,
                                      color: controller.selectedindex == index
                                          ? Colors.white
                                          : Color.fromARGB(45, 0, 0, 0)),
                                ),
                              ),
                            ),
                            controller.widgets[controller.selectedindex]
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

Widget _widget(
    {required title,
    required index,
    required Color color,
    required Color fontColor}) {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.all(5),
    margin: EdgeInsets.all(10),
    decoration:
        BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
    child: Text(
      title,
      style: TextStyle(color: fontColor),
    ),
  );
}

Widget buildMenu(context, name, id) {
  return GetBuilder<HomeController>(
    init: HomeController(),
    builder: (controller) => SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 50.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Person(
                    name: null,
                    image: controller.info?.image,
                    gender: controller.info?.gender),
                const SizedBox(height: 16.0),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "$name",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'ID: ${controller.info?.idNo.toString()}',
                    style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     Text(
                //       "Id: ",
                //       style: const TextStyle(
                //           color: Colors.white,
                //           fontSize: 18,
                //           fontWeight: FontWeight.bold),
                //     ),
                //     SelectableText(
                //       "${id}",
                //       style: const TextStyle(
                //           color: Colors.white,
                //           fontSize: 18,
                //           fontWeight: FontWeight.bold),
                //     ),
                //   ],
                // ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              if (controller.guest) {
                AppHelper().shouldSignin();
                return;
              }
              Get.to(() => Profile());
            },
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.color1,
                  boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 2)]),
              margin: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'profile'.tr,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Icon(Icons.account_circle_outlined,
                      size: 20.0, color: Colors.white),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ),
          ),
          GetBuilder<HomeController>(
            builder: (controller) => InkWell(
              onTap: () {
                if (controller.guest) {
                  AppHelper().shouldSignin();
                  return;
                }
                PersonsAlertWidget(controller: controller);
                // Get.to(() => AddNewRequest(
                //       ReciverId: 'dd',
                //     ));
              },
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.color1,
                    boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 2)]),
                margin: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'addorder'.tr,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Icon(Icons.online_prediction_rounded,
                        size: 20.0, color: Colors.white),
                    SizedBox(
                      width: 5,
                    ),
                  ],
                ),
              ),
            ),
          ),
          GetBuilder<RequestsController>(
            builder: (controller) => InkWell(
              onTap: () {
                if (controller.info?.name == 'guest') {
                  AppHelper().shouldSignin();
                  return;
                }
                controller.getDrafts();
                Get.to(() => Drafts());
              },
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.color1,
                    boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 2)]),
                margin: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'drafts'.tr,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Icon(Icons.online_prediction_rounded,
                        size: 20.0, color: Colors.white),
                    SizedBox(
                      width: 5,
                    ),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              if (controller.guest) {
                AppHelper().shouldSignin();
                return;
              }
              Get.to(() => CategoriesMangment());
            },
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.color1,
                  boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 2)]),
              margin: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'cat'.tr,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Icon(Icons.category, size: 20.0, color: Colors.white),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Get.to(() => ItemsComparing());
            },
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.color1,
                  boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 2)]),
              margin: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'compa'.tr,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Icon(Icons.compare_arrows_outlined,
                      size: 20.0, color: Colors.white),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ),
          ),
          GetBuilder<SettingController>(
            init: SettingController(),
            builder: (controller) => InkWell(
              onTap: () {
                controller.changeLang();
              },
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.color1,
                    boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 2)]),
                margin: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'lang'.tr,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Icon(Icons.language, size: 20.0, color: Colors.white),
                    SizedBox(
                      width: 5,
                    ),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              controller.signOut();
            },
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.color1,
                  boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 2)]),
              margin: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'logout'.tr,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Icon(Icons.logout, size: 20.0, color: Colors.white),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

PersonsAlertWidget({required HomeController controller}) {
  RequestsController requestsController = Get.put(RequestsController());
  return Get.defaultDialog(
    title: '',
    content: SizedBox(
        height: 128,
        width: Get.width - 100,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.familyList.length,
            itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    requestsController.getInfo();
                    Get.to(() => AddNewRequest(
                        isNew: false,
                        isEdit: false,
                        ReciverId: controller.familyList[index].id));
                  },
                  child: Person(
                      name: controller.familyList[index].name.toString(),
                      image: controller.familyList[index].image,
                      gender: controller.familyList[index].gender),
                ))),
  );
}
