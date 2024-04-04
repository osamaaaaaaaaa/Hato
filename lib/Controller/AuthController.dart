// ignore_for_file: non_constant_identifier_names, avoid_print, unused_local_variable, file_names, prefer_final_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/Material.dart';
import 'package:get/get.dart';
import 'package:superconnect/View/Screens/Auth/CodeInsert.dart';
import 'package:superconnect/View/Screens/Home/Home.dart';

import '../Model/UserModel.dart';
import '../Utils/Helper.dart';

class AuthController extends GetxController {
  var _auth = FirebaseAuth.instance;
  UserModel? model;

  int gender = 0;
  switchGender() {
    if (gender == 0) {
      gender = 1;
      update();
    } else {
      gender = 0;
      update();
    }
  }

  bool loading = false;
  var db = FirebaseFirestore.instance;
  //Register({required UserModel model}) async {
  // loading = true;
  // update();
  // try {
  //   final credential =
  //       await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //     email: model.email!.trim().toString(),
  //     password: model.pass!.trim().toString(),
  //   );
  //   AddNewUserToDb(model: model, userId: credential.user?.uid);
  // } on FirebaseAuthException catch (e) {
  //   if (e.code == 'weak-password') {
  //     loading = false;

  //     update();
  //     AppHelper.errorsnackbar('The password provided is too weak.');
  //   } else if (e.code == 'email-already-in-use') {
  //     loading = false;
  //     update();
  //     AppHelper.errorsnackbar('The account already exists for that email.');
  //   }
  // } catch (e) {
  //   loading = false;
  //   update();
  //   print(e);
  // }
  //}

  signIn({required emailAddress, required password}) async {
    User? user = FirebaseAuth.instance.currentUser;
    print(user);
    // loading = true;
    // update();
    // try {
    //   final credential = await FirebaseAuth.instance
    //       .signInWithEmailAndPassword(email: emailAddress, password: password);
    //   Get.off(() => Home());
    // } on FirebaseAuthException catch (e) {
    //   if (e.code == 'user-not-found') {
    //     loading = false;
    //     update();
    //     print('No user found for that email.');
    //   } else if (e.code == 'wrong-password') {
    //     loading = false;
    //     update();

    //     print('Wrong password provided for that user.');
    //   }
    //   loading = false;
    // }
  }

  AddNewUserToDb({required UserModel model, required userId}) async {
    model.gender = gender;
    model.family = [];
    model.id = userId;
    model.groups = [];

    await db
        .collection('users')
        .doc(userId)
        .set(model.toJson())
        .then((value) {});
    Get.offAll(() => Home());
    loading = false;
  }

  CheckIfExist(mobile) async {
    loading = true;
    update();
    await db
        .collection('users')
        .where('mobile', isEqualTo: mobile)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        phoneSignIn(phoneNumber: mobile);
      } else {
        AppHelper.errorsnackbar('error');
        loading = false;
        update();
      }
    });
  }

  String? verificationId;
  Future<void> phoneSignIn({required String phoneNumber}) async {
    loading = true;
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: _onVerificationCompleted,
        verificationFailed: _onVerificationFailed,
        codeSent: _onCodeSent,
        codeAutoRetrievalTimeout: _onCodeTimeout);
  }

  _onVerificationCompleted(PhoneAuthCredential authCredential) async {
    // print("verification completed ${authCredential.smsCode}");
    // User? user = FirebaseAuth.instance.currentUser;

    // print(authCredential.smsCode);

    // if (authCredential.smsCode != null) {
    //   try {
    //     UserCredential credential =
    //         await user!.linkWithCredential(authCredential);
    //   } on FirebaseAuthException catch (e) {
    //     if (e.code == 'provider-already-linked') {
    //       await _auth.signInWithCredential(authCredential);
    //     }
    //   }

    //   // Navigator.pushNamedAndRemoveUntil(
    //   //     context, Constants.homeNavigate, (route) => false);
    // }
  }

  _onVerificationFailed(FirebaseAuthException exception) {
    if (exception.code == 'invalid-phone-number') {
      showMessage("The phone number entered is invalid!");
    }
  }

  _onCodeSent(String verificationId, int? forceResendingToken) {
    this.verificationId = verificationId;
    Get.to(() => CodeInsert());
    loading = false;
    update();
    print(forceResendingToken);
    print("code sent");
  }

  _onCodeTimeout(String timeout) {
    return null;
  }

  checkuser({required smscode}) async {
    loading = true;
    update();
    String smsCode = smscode;

    // Create a PhoneAuthCredential with the code
    try {
      PhoneAuthCredential _credential = PhoneAuthProvider.credential(
          verificationId: verificationId!, smsCode: smsCode);

      await _auth.signInWithCredential(_credential);

      _checkUserIsExist(user: _auth.currentUser!, credential: _credential);
    } catch (e) {
      AppHelper.errorsnackbar(e.toString());
      loading = false;
      update();
    }
  }

  _checkUserIsExist(
      {required User user, required PhoneAuthCredential credential}) async {
    await db.collection('users').doc(user.uid).get().then((value) async {
      if (value.data() == null) {
        AddNewUserToDb(model: model!, userId: user.uid.toString());
      } else {
        Get.offAll(() => Home());
      }
    });
  }

  void showMessage(String errorMessage) {
    showDialog(
        context: Get.context!,
        builder: (BuildContext builderContext) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(errorMessage),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () async {
                  Navigator.of(builderContext).pop();
                },
              )
            ],
          );
        }).then((value) {});
  }
}
