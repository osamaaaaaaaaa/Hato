// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../Utils/Colors.dart';

class DateBar extends StatelessWidget {
  String? name;

  DateBar({required this.name});
  var today = DateFormat("EEE, MMM d").format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // margin: const EdgeInsets.all(10),
              child: Text(
                "Let\'s Make our ",
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  color: AppColors.color1,
                  fontSize: 16,
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  // margin: const EdgeInsets.all(10),
                  child: Text(
                    "Lives",
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      color: AppColors.color1,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  // margin: const EdgeInsets.all(10),
                  child: Text(
                    " Easier",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.color1,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        Column(
          children: [
            Container(
              // margin: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Text(
                    name.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.color1),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Icon(Icons.account_circle_outlined,
                      size: 30.0, color: AppColors.color1),
                ],
              ),
            ),
            Container(
              // margin: const EdgeInsets.all(10),
              child: Text(
                today,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.color1,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
