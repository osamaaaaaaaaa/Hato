// // ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, must_be_immutable

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:superconnect/Controller/RequestsController.dart';
// import 'package:superconnect/Model/UserModel.dart';
// import 'package:superconnect/Utils/Colors.dart';
// import 'package:superconnect/Utils/Helper.dart';
// import 'package:superconnect/View/Widgets/AppBar.dart';
// import 'package:superconnect/View/Widgets/Button.dart';
// import 'package:superconnect/View/Widgets/RequestWidget.dart';

// import 'MyRequestPreview.dart';

// class AddRequest extends StatelessWidget {
//   String? ReciverId, cat;
//   AddRequest({required this.ReciverId, required this.cat});
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<RequestsController>(
//       init: RequestsController(),
//       builder: (controller) => Scaffold(
//         backgroundColor: AppColors.color1,
//         body: controller.info == null
//             ? Center(
//                 child: SizedBox(
//                   width: Get.width * 0.6,
//                   child: LinearProgressIndicator(
//                     color: Colors.grey,
//                     backgroundColor: AppColors.color1,
//                   ),
//                 ),
//               )
//             : SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     App_Bar(
//                         iconData: Icons.add,
//                         title: 'order'.tr,
//                         color: Colors.white),
//                     SizedBox(
//                       height: 30,
//                     ),
                 
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: controller.requestWidgetList,
//                     ),
//                     button(
//                         color: Colors.white,
//                         title: 'addorder'.tr,
//                         fontsize: 16,
//                         fontColor: AppColors.color1,
//                         height: 40,
//                         function: () {
//                           controller.ordernameControllerList
//                               .add(TextEditingController());
//                           controller.ordernoteControllerList
//                               .add(TextEditingController());
//                           controller.ordercatControllerList
//                               .add(TextEditingController(text: cat.toString()));
//                           //controller.categories.add('جبن');
//                           controller.requestWidgetList.add(reqestWidget(
//                               controller: controller,
//                               cat: controller.ordercatControllerList[
//                                   controller.requestWidgetList.length],
//                               index: controller.requestWidgetList.length,
//                               categorieslist: controller.info!.categories,
//                               note: controller.ordernoteControllerList[
//                                   controller.requestWidgetList.length],
//                               name: controller.ordernameControllerList[
//                                   controller.requestWidgetList.length]));
//                           controller.update();
//                         },
//                         width: Get.width * 0.8),
//                     button(
//                         color: Colors.white,
//                         title: 'send'.tr,
//                         fontsize: 16,
//                         fontColor: AppColors.color1,
//                         height: 40,
//                         function: () {
//                           Request requestmodel = Request(
//                               items: [],
//                               reciverId: ReciverId,
//                               id: (controller.info!.request!.length + 1)
//                                   .toString(),
//                               status: 2,
//                               createdDate: DateTime.now().toString(),
//                               senderId: controller.user);
//                           for (var i = 0;
//                               i < controller.requestWidgetList.length;
//                               i++) {
//                             if (controller.ordernameControllerList[i].text
//                                     .isNotEmpty ||
//                                 controller.ordercatControllerList[i].text
//                                     .isNotEmpty) {
//                               requestmodel.items?.add(Items(
//                                   name: controller
//                                       .ordernameControllerList[i].text
//                                       .toString(),
//                                   status: 2,
//                                   notes: controller
//                                       .ordernoteControllerList[i].text
//                                       .toString(),
//                                   cat: controller.ordercatControllerList[i].text
//                                       .toString()));
//                             }
//                           }
//                           if (controller.requestWidgetList.isEmpty) {
//                             AppHelper.errorsnackbar('error');
//                             return;
//                           }
//                           controller.addrequest(request: requestmodel);
//                         },
//                         width: Get.width * 0.8),
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }
// }

// Widget _Listview(
//     {required List<Items> list,
//     required RequestsController controller,
//     required int requestIndex}) {
//   return Container(
//     padding: EdgeInsets.all(10),
//     margin: EdgeInsets.symmetric(horizontal: 10),
//     decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(20), topRight: Radius.circular(20))),
//     child: ListView.builder(
//       itemCount: list.length,
//       itemBuilder: (context, index) => ItemWidget(
//           item: list[index],
//           controller: controller,
//           index: index,
//           requestIndex: requestIndex),
//     ),
//   );
// }
