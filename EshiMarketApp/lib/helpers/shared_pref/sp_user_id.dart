import 'package:flutter/cupertino.dart';
import 'package:eshi_market/helpers/shared_pref.dart';
import 'dart:developer' as developer;

const keyUserId = "DEFAULT_SP_USERID";
const keyUserName = "USER_FULL_NAME";

storeUserId(String v) async {
  SharedPref sharedPref = SharedPref();
  await sharedPref.save(keyUserId, v);
}

storeUserFullName(String v) async {
  SharedPref sharedPref = SharedPref();
  await sharedPref.save(keyUserName, v);
}

Future<String> readUserFullName() async {
  developer.log("readUserFullName() called!", name: "DrawerWidget");
  SharedPref sharedPref = SharedPref();
  String val = await sharedPref.read(keyUserName);
  developer.log("Value is ${val}", name: "DrawerWidget");
  return val;
}

Future<String> readUserId() async {
  SharedPref sharedPref = SharedPref();
  String val = await sharedPref.read(keyUserId);
  return val;
}

destroyUserId(BuildContext context) async {
  SharedPref sharedPref = SharedPref();
  await sharedPref.save(keyUserId, null);
}
