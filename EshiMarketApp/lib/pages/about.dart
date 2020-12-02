import 'package:flutter/material.dart';
import 'package:eshi_market/helpers/tools.dart';
import 'package:eshi_market/labelconfig.dart';
import 'package:eshi_market/widgets/menu_item.dart';
import 'package:eshi_market/widgets/woosignal_ui.dart';
import 'package:package_info/package_info.dart';

class AboutPage extends StatefulWidget {
  AboutPage();

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  _AboutPageState();
  var _version = "Getting version...";
  @override
  void initState() {
    super.initState();
    Future<String> futstring = _getVersion();
    futstring.then((value) => {
          setState(() {
            _version = value;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(trans(context, "About"),
            style: Theme.of(context).primaryTextTheme.headline6),
        centerTitle: true,
      ),
      body: SafeArea(
        minimum: safeAreaDefault(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: storeLogo(),
              flex: 2,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  wsMenuItem(
                    context,
                    title: trans(context, "Privacy policy"),
                    leading: Icon(Icons.people, color: Colors.orangeAccent),
                    action: _actionPrivacy,
                  ),
                  wsMenuItem(
                    context,
                    title: trans(context, "Terms and conditions"),
                    leading:
                        Icon(Icons.description, color: Colors.orangeAccent),
                    action: _actionTerms,
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Text("Version: $_version"))
                ],
              ),
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _getVersion() async {
    PackageInfo info = await PackageInfo.fromPlatform();
    return info.version;
  }

  void _actionTerms() {
    openBrowserTab(url: app_terms_url);
  }

  void _actionPrivacy() {
    openBrowserTab(url: app_privacy_url);
  }
}
