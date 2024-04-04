// ignore_for_file: non_constant_identifier_names, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:superconnect/Utils/Colors.dart';
import 'package:superconnect/Utils/Images.dart';

Widget Person(
    {String? imageassets,
    required String? name,
    required image,
    required int? gender}) {
  return Container(
    margin: const EdgeInsets.all(5),
    child: Column(
      children: [
        imageassets != null
            ? Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(color: AppColors.color1, blurRadius: 2)
                    ]),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    imageassets,
                    height: 60,
                    width: 60,
                  ),
                ),
              )
            : image == null
                ? gender == 0
                    ? Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(color: AppColors.color1, blurRadius: 2)
                            ]),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(
                            AppImages.male,
                            height: 60,
                            width: 60,
                          ),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(color: AppColors.color1, blurRadius: 2)
                            ]),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.asset(
                              AppImages.female,
                              height: 60,
                              width: 60,
                            )),
                      )
                : Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: AppColors.color1, blurRadius: 2)
                        ]),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                          image,
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        ))),
        if (name != null)
          const SizedBox(
            height: 5,
          ),
        if (name != null)
          Text(
            name.toString(),
            style: const TextStyle(
                color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 15),
          )
      ],
    ),
  );
}
