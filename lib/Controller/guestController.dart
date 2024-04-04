import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class guestController extends GetxController {
  FirebaseFirestore db = FirebaseFirestore.instance;
  Map<dynamic, dynamic>? contactMap;

  String? about;
  guestController() {
    get_about();
  }

  get_about() async {
    await db.collection('about').doc('about').get().then((value) {
      if (value.data() == null) {
        return;
      }
      about = value.get('text');
      update();
    });
  }

  getContact() async {
    await db.collection('AppConst').doc('url').get().then((value) async {
      if (value.data() == null) {
        return;
      }
      contactMap = value.data();
    });
    update();
  }
}
