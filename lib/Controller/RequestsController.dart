import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:superconnect/Services/ApiServices.dart';
import 'package:superconnect/Utils/Helper.dart';

import '../Model/UserModel.dart';

class RequestsController extends GetxController {
  // List<TextEditingController> ordernameControllerList = [];
  // List<TextEditingController> ordernoteControllerList = [];
  // List<TextEditingController> ordercatControllerList = [];
  List<Items>? itemsList = [];
  //List<String> categories = [];
  // List<Widget> requestWidgetList = [];
  var db = FirebaseFirestore.instance;
  var user = FirebaseAuth.instance.currentUser?.uid;
  UserModel? info;
  List<Request> drafts = [];
  Request? NewRequestModel = Request(items: []);
  String? NewRequestCategoryName;
  String? NewRequestCategoryImage;

  RequestsController() {
    getInfo();
    getDrafts();
  }
  bool? loading = false;
  getInfo() async {
    loading = true;
    update();
    await db.collection('users').doc(user).get().then((value) {
      if (value.data() != null) {
        info = UserModel.fromJson(value.data()!);
        getFamily();
      }
    });
    loading = false;
    update();
  }

  List<UserModel> familyList = [];

  getFamily() async {
    familyList.clear();

    update();
    if (info!.family!.isNotEmpty) {
      for (var element in info!.family!) {
        await db.collection('users').doc(element).get().then((value) {
          if (value.data() != null) {
            familyList.add(UserModel.fromJson(value.data()!));
          }
        });
        loading = false;
        update();
      }
    }
    loading = false;

    update();
  }

  getDrafts() async {
    drafts.clear();
    await db
        .collection('users')
        .doc(user)
        .collection('drafts')
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        for (var e in value.docs) {
          drafts.add(Request.fromJson(e.data()));
        }
      }
    });
    update();
  }

  int getPersonById({required userId}) {
    return familyList.indexWhere((element) => element.id == userId);
  }

  addrequest({required Request request}) async {
    request.status = 2;
    request.createdDate = DateTime.now().toString();
    request.id =
        '${info?.request?.length}${DateTime.now().microsecond.toString()}';

    info?.request?.add(request);
    Get.back();
    AppHelper.succssessnackbar('');
    await db.collection('users').doc(user).update(info!.toJson());
    await db
        .collection('users')
        .doc(request.reciverId)
        .get()
        .then((value) async {
      UserModel _usermodel = UserModel.fromJson(value.data()!);
      _usermodel.request?.add(request);
      await db
          .collection('users')
          .doc(_usermodel.id)
          .update(_usermodel.toJson());
    });
    ApiServices().sendNotification(
        body: 'New Order !',
        title: 'قام ${info?.name} بطلب منك',
        token: familyList[familyList
                .indexWhere((element) => element.id == request.reciverId)]
            .token);
    NewRequestModel = Request(items: []);
    update();
  }

  adddraft({required Request request}) async {
    Get.back();

    AppHelper.succssessnackbar('');
    await db
        .collection('users')
        .doc(user)
        .collection('drafts')
        .add(request.toJson())
        .then((value) async {
      request.id = value.id;
      await db
          .collection('users')
          .doc(user)
          .collection('drafts')
          .doc(value.id)
          .update(request.toJson());
    });
    getDrafts();

    update();
  }

  editDraft({required Request request}) async {
    await db
        .collection('users')
        .doc(user)
        .collection('drafts')
        .doc(request.id)
        .update(request.toJson());
    Get.back();
    AppHelper.succssessnackbar('');
    getDrafts();
  }

  updateuser(index) async {
    info?.request
        ?.where((element) => element.id == index.toString())
        .toList()
        .first
        .items = itemsList;

    await db.collection('users').doc(user).update(info!.toJson());
  }

  updateRequestStatus({required Request request, required int stat}) async {
    info?.request
        ?.where((element) => element.id == request.id.toString())
        .toList()
        .first
        .status = stat;
    await db.collection('users').doc(user).update(info!.toJson());
    update();
  }
}
