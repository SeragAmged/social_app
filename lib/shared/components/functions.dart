import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/shared/components/variables.dart';
import 'package:social_app/shared/network/remote/firebase_constants.dart';
import '../network/local/cache_helper.dart';

void navigateTo(context, pageTo) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => pageTo),
  );
}

void navigateToWithReplacement(context, pageTo) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => pageTo),
    (Route<dynamic> route) => false,
  );
}

void uIdSaveLocal(String myuId) {
  uId = myuId;
  CacheHelper.setData(key: userCollectionId, value: myuId);
  CacheHelper.setData(key: "firstLogin", value: "done");
}

void logOut(context) async {
  FirebaseAuth.instance.signOut();
  await CacheHelper.removeData(key: userCollectionId);
  await CacheHelper.removeData(key: "firstLogin");
  navigateToWithReplacement(context, LoginScreen());
}
