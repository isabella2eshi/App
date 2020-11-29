import 'package:eshi_market/helpers/shared_pref/sp_auth.dart';
import 'package:eshi_market/helpers/tools.dart';
import 'package:flutter/material.dart';

import '../labelconfig.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
  Function onTap;
}

class AppDrawer extends StatelessWidget {
  var drawer_items = <DrawerItem>[
    DrawerItem("Acount", Icons.account_box_rounded),
    DrawerItem("Cart", Icons.shopping_cart_rounded),
    DrawerItem("About Us", Icons.help_center_rounded)
  ];

  @override
  Widget build(BuildContext context) {
    var items = <Widget>[];
    var head = FutureBuilder<Widget>(
      builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
        if (!snapshot.hasData) {
          // while data is loading:
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          // data loaded:
          final header = snapshot.data;
          items[0] = header;
          return header;
        }
      },
    );
    items.add(head);
    for (var i = 0; i < drawer_items.length; i++) {
      var d = drawer_items[i];
      var item = ListTile(
        title: Text(d.title),
        leading: Icon(
          d.icon,
          color: Colors.orange,
        ),
        onTap: d.onTap,
      );
      items.add(item);
    }
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: items,
    ));
  }

  void goAccount(context) async {
    if (use_wp_login == true && !(await authCheck())) {
      UserAuth.instance.redirect = "/account-detail";
      Navigator.of(context).pushNamed("/account-landing");
      return;
    }
    Navigator.pushNamed(context, "/account-detail");
  }

  Future<Widget> drawHead(context) async {
    // TODO: Create shared pref to store user value.
    // Show Login/Register button if not logged in but user info if logged in
  }

  void goCart(context) {
    Navigator.of(context).pushNamed("/cart");
  }

  void goAbout(context) {
    Navigator.of(context).pushNamed("/about");
  }
}
