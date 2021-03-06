import 'package:flutter/material.dart';
import 'package:eshi_market/helpers/shared_pref/sp_auth.dart';
import 'package:eshi_market/helpers/shared_pref/sp_user_id.dart';
import 'package:eshi_market/helpers/tools.dart';
import 'package:eshi_market/labelconfig.dart';
import 'package:eshi_market/widgets/buttons.dart';
import 'package:eshi_market/widgets/woosignal_ui.dart';
import 'package:woosignal/helpers/shared_pref.dart';
import 'package:wp_json_api/exceptions/empty_username_exception.dart';
import 'package:wp_json_api/exceptions/existing_user_email_exception.dart';
import 'package:wp_json_api/exceptions/existing_user_login_exception.dart';
import 'package:wp_json_api/exceptions/invalid_nonce_exception.dart';
import 'package:wp_json_api/exceptions/user_already_exist_exception.dart';
import 'package:wp_json_api/exceptions/username_taken_exception.dart';
import 'package:wp_json_api/models/responses/wp_user_register_response.dart';
import 'package:wp_json_api/wp_json_api.dart';

class AccountRegistrationPage extends StatefulWidget {
  AccountRegistrationPage();

  @override
  _AccountRegistrationPageState createState() =>
      _AccountRegistrationPageState();
}

class _AccountRegistrationPageState extends State<AccountRegistrationPage> {
  _AccountRegistrationPageState();

  bool _hasTappedRegister;
  TextEditingController _tfEmailAddressController;
  TextEditingController _tfPasswordController;
  TextEditingController _tfFirstNameController;
  TextEditingController _tfLastNameController;

  @override
  void initState() {
    super.initState();

    _hasTappedRegister = false;
    _tfEmailAddressController = TextEditingController();
    _tfPasswordController = TextEditingController();
    _tfFirstNameController = TextEditingController();
    _tfLastNameController = TextEditingController();
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
        title: Text(
          "Register",
          style: Theme.of(context).primaryTextTheme.headline6,
        ),
        centerTitle: true,
      ),
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        minimum: safeAreaDefault(),
        child: Column(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(top: 10),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: wsTextEditingRow(
                        context,
                        heading: trans(context, "First Name"),
                        controller: _tfFirstNameController,
                        shouldAutoFocus: true,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    Flexible(
                      child: wsTextEditingRow(
                        context,
                        heading: trans(context, "Last Name"),
                        controller: _tfLastNameController,
                        shouldAutoFocus: false,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ],
                )),
            wsTextEditingRow(
              context,
              heading: trans(context, "Email address"),
              controller: _tfEmailAddressController,
              shouldAutoFocus: false,
              keyboardType: TextInputType.emailAddress,
            ),
            wsTextEditingRow(
              context,
              heading: trans(context, "Password"),
              controller: _tfPasswordController,
              shouldAutoFocus: true,
              obscureText: true,
            ),
            Padding(
              child: wsPrimaryButton(context,
                  title: trans(context, "Sign up"),
                  action: _hasTappedRegister ? null : _signUpTapped),
              padding: EdgeInsets.only(top: 10),
            ),
            Padding(
              child: InkWell(
                child: RichText(
                  text: TextSpan(
                    text: trans(
                            context, "By tapping \"Register\" you agree to ") +
                        app_name +
                        '\'s ',
                    children: <TextSpan>[
                      TextSpan(
                          text: trans(context, "terms and conditions"),
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: '  ' + trans(context, "and") + '  '),
                      TextSpan(
                          text: trans(context, "privacy policy"),
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                    style: TextStyle(color: Colors.black45),
                  ),
                  textAlign: TextAlign.center,
                ),
                onTap: _viewTOSModal,
              ),
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
          ],
        ),
      ),
    );
  }

  _signUpTapped() async {
    String email = _tfEmailAddressController.text;
    String password = _tfPasswordController.text;
    String firstName = _tfFirstNameController.text;
    String lastName = _tfLastNameController.text;

    if (email != null) {
      email = email.trim();
    }

    if (!isEmail(email)) {
      showEdgeAlertWith(context,
          title: trans(context, "Oops"),
          desc: trans(context, "That email address is not valid"),
          style: EdgeAlertStyle.DANGER);
      return;
    }

    if (password.length <= 5) {
      showEdgeAlertWith(context,
          title: trans(context, "Oops"),
          desc: trans(context, "Password must be a min 6 characters"),
          style: EdgeAlertStyle.DANGER);
      return;
    }

    if (_hasTappedRegister == false) {
      setState(() {
        _hasTappedRegister = true;
      });

      String username =
          (email.replaceAll(new RegExp(r'(@|\.)'), "")) + randomStr(4);

      WPUserRegisterResponse wpUserRegisterResponse;
      try {
        wpUserRegisterResponse = await WPJsonAPI.instance.api(
          (request) => request.wpRegister(
            email: email.toLowerCase(),
            password: password,
            username: username,
          ),
        );
      } on UsernameTakenException catch (e) {
        showEdgeAlertWith(context,
            title: trans(context, "Oops!"),
            desc: trans(context, e.message),
            style: EdgeAlertStyle.DANGER);
      } on InvalidNonceException catch (_) {
        showEdgeAlertWith(context,
            title: trans(context, "Invalid details"),
            desc: trans(
                context, "Something went wrong, please contact our store"),
            style: EdgeAlertStyle.DANGER);
      } on ExistingUserLoginException catch (_) {
        showEdgeAlertWith(context,
            title: trans(context, "Oops!"),
            desc: trans(context, "A user already exists"),
            style: EdgeAlertStyle.DANGER);
      } on ExistingUserEmailException catch (_) {
        showEdgeAlertWith(context,
            title: trans(context, "Oops!"),
            desc: trans(context, "That email is taken, try another"),
            style: EdgeAlertStyle.DANGER);
      } on UserAlreadyExistException catch (_) {
        showEdgeAlertWith(context,
            title: trans(context, "Oops!"),
            desc: trans(context, "A user already exists"),
            style: EdgeAlertStyle.DANGER);
      } on EmptyUsernameException catch (e) {
        showEdgeAlertWith(context,
            title: trans(context, "Oops!"),
            desc: trans(context, e.message),
            style: EdgeAlertStyle.DANGER);
      } on Exception catch (_) {
        showEdgeAlertWith(context,
            title: trans(context, "Oops!"),
            desc: trans(context, "Something went wrong"),
            style: EdgeAlertStyle.DANGER);
      } finally {
        setState(() {
          _hasTappedRegister = false;
        });
      }

      if (wpUserRegisterResponse != null &&
          wpUserRegisterResponse.status == 200) {
        String token = wpUserRegisterResponse.data.userToken;
        authUser(token);
        storeUserId(wpUserRegisterResponse.data.userId.toString());

        await WPJsonAPI.instance.api((request) => request
            .wpUpdateUserInfo(token, firstName: firstName, lastName: lastName));

        showEdgeAlertWith(context,
            title: trans(context, "Hello") + " $firstName",
            desc: trans(context, "you're now logged in"),
            style: EdgeAlertStyle.SUCCESS,
            icon: Icons.account_circle);
        navigatorPush(context,
            routeName: UserAuth.instance.redirect, forgetLast: 2);
      }
    }
  }

  _viewTOSModal() {
    showPlatformAlertDialog(context,
        title: trans(context, "Actions"),
        subtitle: trans(context, "View Terms and Conditions or Privacy policy"),
        actions: [
          dialogAction(context,
              title: trans(context, "Terms and Conditions"),
              action: _viewTermsConditions),
          dialogAction(context,
              title: trans(context, "Privacy Policy"),
              action: _viewPrivacyPolicy),
        ]);
  }

  void _viewTermsConditions() {
    Navigator.pop(context);
    openBrowserTab(url: app_terms_url);
  }

  void _viewPrivacyPolicy() {
    Navigator.pop(context);
    openBrowserTab(url: app_privacy_url);
  }
}
