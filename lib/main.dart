// ignore_for_file: prefer_const_constructors, camel_case_types, unused_import, await_only_futures
// ignore_for_file: use_key_in_widget_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:superconnect/Bindings/bindings.dart';
import 'package:superconnect/Local/AppConst.dart';
import 'package:superconnect/Local/Local.dart';
import 'package:superconnect/Utils/Helper.dart';
import 'package:superconnect/View/Screens/Auth/Login.dart';
import 'package:superconnect/View/Screens/Auth/Register.dart';
import 'package:superconnect/View/Screens/Home/Home.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'firebase_options.dart';

String? lang;
Widget? _widget;
late FirebaseMessaging messaging;
void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  getuserstate();
  getLang();
  messaging = FirebaseMessaging.instance;

  messaging.setForegroundNotificationPresentationOptions(
    alert: true,
    sound: true,
    badge: true,
  );

  //NotificationSettings settings
  await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    provisional: true,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(app());
}

getLang() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  lang = await preferences.getString(AppConst.Lang);
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

forgroundnotifocations() async {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {}
  });
}

class app extends StatelessWidget {
  const app({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: Binding(),
      textDirection: TextDirection.ltr,
      locale: lang == null ? Locale('ar') : Locale(lang!),
      translations: Lan(),
      home: _widget,
    );
  }
}

getuserstate() async {
  await FirebaseAuth.instance.authStateChanges().listen((User? user) async {
    // AppHelper.errorsnackbar(user.toString());
    if (user == null) {
      _widget = Login();
      return;
    } else {
      _widget = Home();
    }
  });
}
