import 'package:get/get.dart';
import 'package:superconnect/Controller/AuthController.dart';
import 'package:superconnect/Controller/ChatController.dart';
import 'package:superconnect/Controller/HomeController.dart';
import 'package:superconnect/Controller/RequestsController.dart';
import 'package:superconnect/Controller/SettingController.dart';

class Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => AuthController());
    Get.lazyPut(() => RequestsController());
    Get.lazyPut(() => ChatController());
    Get.lazyPut(() => SettingController());
  }
}
