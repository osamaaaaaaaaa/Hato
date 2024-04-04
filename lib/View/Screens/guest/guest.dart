import 'package:flutter/Material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:superconnect/Utils/Colors.dart';
import 'package:superconnect/Utils/Images.dart';
import 'package:superconnect/View/Screens/Auth/Register.dart';
import 'package:superconnect/View/Screens/Home/landing.dart';
import 'package:superconnect/View/Screens/guest/about.dart';
import 'package:superconnect/View/Screens/guest/contact_us.dart';
import 'package:superconnect/View/Widgets/datebar.dart';

class guest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Container(
                margin: EdgeInsets.all(10), child: DateBar(name: 'Guest')),
            SizedBox(
              height: 20,
            ),
            ClipRRect(
                borderRadius: BorderRadius.circular(75),
                child: Image.asset(
                  AppImages.logo,
                  height: 150,
                  width: 150,
                )),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Get.to(() => Register());
              },
              child: _button(
                  title: 'تسجيل حساب جديد',
                  icon: Icons.account_circle,
                  subtitle: 'الاسم,البريد الالكتروني,الخ'),
            ),
            InkWell(
              onTap: () {
                Get.to(() => about());
              },
              child: _button(
                  title: 'عن التطبيق',
                  icon: Icons.info_outline,
                  subtitle: 'اعرف المزيد عن تطبيق Hato'),
            ),
            InkWell(
              onTap: () {
                Get.to(() => contact_us());
              },
              child: _button(
                  title: 'تواصل معنا',
                  icon: Icons.mail,
                  subtitle: 'تواصل معنا عن طريق منصات التواصل المختلفه'),
            ),
            InkWell(
              onTap: () {
                Get.back();
              },
              child: _button(
                  title: 'تسجيل الخروج',
                  icon: Icons.logout_outlined,
                  subtitle: 'ننتظرك للعوده قريبا'),
            ),
          ],
        ),
      ),
    );
  }
}

class _button extends StatelessWidget {
  late String title;
  late IconData icon;
  late String subtitle;

  _button({required this.title, required this.icon, required this.subtitle});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.color1,
      ),
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    // alignment: Alignment.centerLeft,
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              icon,
              color: Colors.white,
              size: 25,
            ),
          ],
        ),
      ),
    );
  }
}
