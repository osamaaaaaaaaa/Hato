// // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

// import 'package:flutter/Material.dart';
// import 'package:get/get.dart';
// import 'package:superconnect/Controller/RequestsController.dart';
// import 'package:superconnect/Utils/Colors.dart';

// Widget reqestWidget(
//     {required int index,
//     required TextEditingController name,
//     required TextEditingController note,
//     required TextEditingController cat,
//     required RequestsController controller,
//     required List? categorieslist}) {
//   return Container(
//     padding: EdgeInsets.all(10),
//     margin: EdgeInsets.all(10),
//     decoration: BoxDecoration(
//         color: Colors.white, borderRadius: BorderRadius.circular(20)),
//     child: Column(
//       children: [
//         SizedBox(
//           height: 10,
//         ),
//         Text(
//           'التفاصيل',
//           style: TextStyle(
//               color: AppColors.color1,
//               fontSize: 16,
//               fontWeight: FontWeight.bold),
//         ),
//         Container(
//             width: Get.width * 0.8,
//             decoration: BoxDecoration(
//                 color: Colors.white, borderRadius: BorderRadius.circular(10)),
//             margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//             child: TextFormField(
//               controller: name,
//               decoration: InputDecoration(
//                   label: Text('ordername'.tr),
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10))),
//             )),
//         Container(
//             width: Get.width * 0.8,
//             decoration: BoxDecoration(
//                 color: Colors.white, borderRadius: BorderRadius.circular(10)),
//             margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//             child: TextFormField(
//               controller: note,
//               decoration: InputDecoration(
//                   label: Text('note'.tr),
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10))),
//             )),
//         Row(
//           children: [
//             Container(
//                 width: Get.width * 0.5,
//                 decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10)),
//                 margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//                 child: TextFormField(
//                   enabled: false,
//                   controller: cat,
//                   decoration: InputDecoration(
//                       label: Text('cat'.tr),
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10))),
//                 )),
//             Container(
//               width: Get.width * 0.2,
//               child: DropdownButton<dynamic>(
//                 value: categorieslist?.first,
//                 icon: const Icon(Icons.arrow_downward),
//                 elevation: 16,
//                 style: const TextStyle(color: AppColors.color1),
//                 underline: Container(
//                   height: 2,
//                   color: AppColors.color1,
//                 ),
//                 onChanged: (dynamic value) {
//                   cat.text = value;
//                 },
//                 items: categorieslist
//                     ?.map<DropdownMenuItem<dynamic>>((dynamic value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//               ),
//             ),
//             InkWell(
//               onTap: () {
//                 controller.requestWidgetList.removeLast();
//                 controller.update();
//               },
//               child: Icon(
//                 Icons.delete,
//                 color: Colors.red,
//               ),
//             )
//           ],
//         ),
//       ],
//     ),
//   );
//   //  ExpandablePanel(
//   //     theme: ExpandableThemeData(iconColor: Colors.white),
//   //     header: Container(
//   //         margin: EdgeInsets.all(10),
//   //         padding: EdgeInsets.all(7),
//   //         child: Container(
//   //             padding: EdgeInsets.all(10),
//   //             decoration: BoxDecoration(
//   //                 borderRadius: BorderRadius.circular(10),
//   //                 color: Colors.white,
//   //                 boxShadow: [
//   //                   BoxShadow(color: AppColors.color1, blurRadius: 5)
//   //                 ]),
//   //             child: Container(
//   //               width: Get.width * 0.6,
//   //               child: Text((index + 1).toString(),
//   //                   style: TextStyle(fontSize: 16, color: AppColors.color1)),
//   //             ))),
//   //     collapsed: Text(
//   //       '',
//   //       softWrap: true,
//   //       maxLines: 2,
//   //       overflow: TextOverflow.ellipsis,
//   //     ),
//   //     expanded: );
// }
