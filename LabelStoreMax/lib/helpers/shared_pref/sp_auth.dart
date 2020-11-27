import 'package:flutter/cupertino.dart';
import 'package:eshi_market/helpers/shared_pref.dart';
import 'package:eshi_market/helpers/shared_pref/sp_user_id.dart';
import 'package:eshi_market/helpers/tools.dart';
import 'package:eshi_market/models/cart.dart';

const keyAuthCheck = "DEFAULT_SP_AUTHCHECK";

Future<bool> authCheck() async {
  SharedPref sharedPref = SharedPref();
  String val = await sharedPref.read(keyAuthCheck);
  return val != null ? true : false;
}

authUser(String v) async {
  SharedPref sharedPref = SharedPref();
  await sharedPref.save(keyAuthCheck, v);
}

Future<String> readAuthToken() async {
  SharedPref sharedPref = SharedPref();
  dynamic val = await sharedPref.read(keyAuthCheck);
  return val.toString();
}

authLogout(BuildContext context) async {
  SharedPref sharedPref = SharedPref();
  await sharedPref.save(keyAuthCheck, null);
  destroyUserId(context);
  Cart.getInstance.clear();
  navigatorPush(context, routeName: "/home", forgetAll: true);
}
