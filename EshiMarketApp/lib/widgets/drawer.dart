import 'package:eshi_market/helpers/shared_pref/sp_auth.dart';
import 'package:eshi_market/helpers/shared_pref/sp_user_id.dart';
import 'package:eshi_market/helpers/tools.dart';
import 'package:flutter/material.dart';
import 'package:wp_json_api/models/responses/wc_customer_info_response.dart';
import 'package:wp_json_api/wp_json_api.dart';
import 'dart:developer' as developer;
import '../labelconfig.dart';

class DrawerItem {
  String title;
  IconData icon;
  var onTap;

  DrawerItem(this.title, this.icon, this.onTap);
}

class AppDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppDarawerState();
}

class _AppDarawerState extends State<AppDrawer> {
  var _draweritems;
  var _drawerhead;
  static const LOG_HEAD = "DrawerWidget";

  @override
  void initState() {
    super.initState();

    _draweritems = <ListTile>[
      ListTile(
        title: Text("Acount"),
        leading: Icon(Icons.account_box_rounded, color: Colors.orangeAccent),
        onTap: goAccount,
      ),
      ListTile(
        title: Text("Cart"),
        leading: Icon(Icons.shopping_cart_rounded, color: Colors.orangeAccent),
        onTap: goCart,
      ),
      ListTile(
        title: Text("About Us"),
        leading: Icon(Icons.help_center_rounded, color: Colors.orangeAccent),
        onTap: goAbout,
      )
    ];

    _drawerhead = CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
    );
    var futdrawerhead = drawHead(context);
    futdrawerhead.then((value) {
      setState(() {
        _drawerhead = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var items = <Widget>[];
    items.add(_drawerhead);
    for (ListTile item in _draweritems) {
      items.add(item);
    }
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: items,
    ));
  }

  void goAccount() async {
    if (use_wp_login == true && !(await authCheck())) {
      UserAuth.instance.redirect = "/account-detail";
      Navigator.of(context).pushNamed("/account-landing");
      return;
    }
    Navigator.pushNamed(context, "/account-detail");
  }

  void goCart() {
    Navigator.of(context).pushNamed("/cart");
  }

  void goAbout() {
    Navigator.of(context).pushNamed("/about");
  }

  Future<Widget> drawHead(context) async {
    if (await authCheck()) {
      String fullname = await readUserFullName();

      return Padding(
          child: UserAccountsDrawerHeader(
              accountName: Text(fullname,
                  style: TextStyle(color: Colors.black, fontSize: 15)),
              accountEmail: Text("Buyer",
                  style: TextStyle(color: Colors.grey, fontSize: 10)),
              decoration: BoxDecoration(color: Colors.white),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.orangeAccent,
                child: Text(
                  fullname[0],
                  style: TextStyle(fontSize: 40.0),
                ),
              )),
          padding: EdgeInsets.only(top: 30));
    } else {
      return Padding(
        child: RaisedButton(
          onPressed: () {
            UserAuth.instance.redirect = '/home';
            Navigator.of(context).pushNamed('/account-landing');
          },
          child: Text("Login/SignUp"),
        ),
        padding: EdgeInsets.fromLTRB(5, 25, 5, 5),
      );
    }
  }
}
