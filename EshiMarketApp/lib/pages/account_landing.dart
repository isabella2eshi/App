import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eshi_market/helpers/shared_pref/sp_auth.dart';
import 'package:eshi_market/helpers/shared_pref/sp_user_id.dart';
import 'package:eshi_market/helpers/tools.dart';
import 'package:eshi_market/labelconfig.dart';
import 'package:eshi_market/widgets/buttons.dart';
import 'package:eshi_market/widgets/woosignal_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wp_json_api/exceptions/incorrect_password_exception.dart';
import 'package:wp_json_api/exceptions/invalid_email_exception.dart';
import 'package:wp_json_api/exceptions/invalid_nonce_exception.dart';
import 'package:wp_json_api/exceptions/invalid_username_exception.dart';
import 'package:wp_json_api/models/responses/wc_customer_info_response.dart';
import 'package:wp_json_api/models/responses/wp_user_login_response.dart';
import 'package:wp_json_api/wp_json_api.dart';
import 'dart:developer' as developer;

class AccountLandingPage extends StatefulWidget {
  AccountLandingPage();

  @override
  _AccountLandingPageState createState() => _AccountLandingPageState();
}

class _AccountLandingPageState extends State<AccountLandingPage> {
  bool _hasTappedLogin;
  TextEditingController _tfEmailController;
  TextEditingController _tfPasswordController;

  @override
  void initState() {
    super.initState();

    _hasTappedLogin = false;
    _tfEmailController = TextEditingController();
    _tfPasswordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  storeLogo(height: 100),
                  Flexible(
                    child: Container(
                      height: 70,
                      padding: EdgeInsets.only(bottom: 20),
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        trans(context, "Login"),
                        textAlign: TextAlign.left,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline4
                            .copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: wsBoxShadow(),
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 8),
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        wsTextEditingRow(context,
                            heading: trans(context, "Email"),
                            controller: _tfEmailController,
                            keyboardType: TextInputType.emailAddress),
                        wsTextEditingRow(context,
                            heading: trans(context, "Password"),
                            controller: _tfPasswordController,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true),
                        wsPrimaryButton(
                          context,
                          title: trans(context, "Login"),
                          action: _hasTappedLogin == true ? null : _loginUser,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            FlatButton(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.account_circle,
                    color: Colors.black38,
                  ),
                  Padding(
                    child: Text(
                      trans(context, "Create an account"),
                      style: Theme.of(context).primaryTextTheme.bodyText1,
                    ),
                    padding: EdgeInsets.only(left: 8),
                  )
                ],
              ),
              onPressed: () {
                Navigator.pushNamed(context, "/account-register");
              },
            ),
            wsLinkButton(context, title: trans(context, "Forgot Password"),
                action: () {
              launch(app_forgot_password_url);
            }),
            Divider(),
            wsLinkButton(context,
                title: trans(context, "Back"),
                action: () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }

  _loginUser() async {
    String email = _tfEmailController.text;
    String password = _tfPasswordController.text;

    if (email != null) {
      email = email.trim();
    }

    if (email == "" || password == "") {
      showEdgeAlertWith(context,
          title: trans(context, "Invalid details"),
          desc: trans(context, "The email and password field cannot be empty"),
          style: EdgeAlertStyle.DANGER);
      return;
    }

    if (!isEmail(email)) {
      showEdgeAlertWith(context,
          title: trans(context, "Oops"),
          desc: trans(context, "That email address is not valid"),
          style: EdgeAlertStyle.DANGER);
      return;
    }

    if (_hasTappedLogin == false) {
      setState(() {
        _hasTappedLogin = true;
      });

      WPUserLoginResponse wpUserLoginResponse;
      try {
        wpUserLoginResponse = await WPJsonAPI.instance.api(
            (request) => request.wpLogin(email: email, password: password));
      } on InvalidNonceException catch (_) {
        showEdgeAlertWith(context,
            title: trans(context, "Invalid details"),
            desc: trans(
                context, "Something went wrong, please contact our store"),
            style: EdgeAlertStyle.DANGER);
      } on InvalidEmailException catch (_) {
        showEdgeAlertWith(context,
            title: trans(context, "Invalid details"),
            desc: trans(context, "That email does not match our records"),
            style: EdgeAlertStyle.DANGER);
      } on InvalidUsernameException catch (_) {
        showEdgeAlertWith(context,
            title: trans(context, "Invalid details"),
            desc: trans(context, "That username does not match our records"),
            style: EdgeAlertStyle.DANGER);
      } on IncorrectPasswordException catch (_) {
        showEdgeAlertWith(context,
            title: trans(context, "Invalid details"),
            desc: trans(context, "That password does not match our records"),
            style: EdgeAlertStyle.DANGER);
      } on Exception catch (_) {
        showEdgeAlertWith(context,
            title: trans(context, "Oops!"),
            desc: trans(context, "Invalid login credentials"),
            style: EdgeAlertStyle.DANGER,
            icon: Icons.account_circle);
      } finally {
        setState(() {
          _hasTappedLogin = false;
        });
      }

      if (wpUserLoginResponse != null && wpUserLoginResponse.status == 200) {
        String token = wpUserLoginResponse.data.userToken;
        authUser(token);
        storeUserId(wpUserLoginResponse.data.userId.toString());
        await _fetchWpUserData(token);
        showEdgeAlertWith(context,
            title: trans(context, "Hello"),
            desc: trans(context, "Welcome back"),
            style: EdgeAlertStyle.SUCCESS,
            icon: Icons.account_circle);
        navigatorPush(context,
            routeName: UserAuth.instance.redirect, forgetLast: 1);
      }
    }
  }

  _fetchWpUserData(userToken) async {
    WCCustomerInfoResponse wcCustomerInfoResponse;
    try {
      wcCustomerInfoResponse = await WPJsonAPI.instance
          .api((request) => request.wcCustomerInfo(userToken));
    } on Exception catch (_) {
      showEdgeAlertWith(
        context,
        title: trans(context, "Oops!"),
        desc: trans(context, "Something went wrong"),
        style: EdgeAlertStyle.DANGER,
      );
    } finally {}

    if (wcCustomerInfoResponse != null &&
        wcCustomerInfoResponse.status == 200) {
      storeUserFullName(wcCustomerInfoResponse.data.firstName +
          " " +
          wcCustomerInfoResponse.data.lastName);
    } else {}
  }
}
