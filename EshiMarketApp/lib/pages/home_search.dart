import 'package:flutter/material.dart';
import 'package:eshi_market/helpers/tools.dart';
import 'package:eshi_market/widgets/buttons.dart';

import '../widgets/woosignal_ui.dart';

class HomeSearchPage extends StatefulWidget {
  HomeSearchPage();

  @override
  _HomeSearchPageState createState() => _HomeSearchPageState();
}

class _HomeSearchPageState extends State<HomeSearchPage> {
  _HomeSearchPageState();

  TextEditingController _txtSearchController;

  @override
  void initState() {
    super.initState();

    _txtSearchController = TextEditingController();
  }

  _actionSearch() {
    Navigator.pushNamed(context, "/product-search",
            arguments: _txtSearchController.text)
        .then((search) {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: storeLogo(height: 60),
        centerTitle: true,
      ),
      body: SafeArea(
        minimum: safeAreaDefault(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Icon(Icons.search, size: 36),
              margin: EdgeInsets.only(bottom: 20),
            ),
            TextField(
              controller: _txtSearchController,
              style: Theme.of(context).primaryTextTheme.headline3,
              keyboardType: TextInputType.text,
              autocorrect: false,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: wsPrimaryButton(
                context,
                title: trans(context, "Search"),
                action: _actionSearch,
              ),
            )
          ],
        ),
      ),
    );
  }
}
