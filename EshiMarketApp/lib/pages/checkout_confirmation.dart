import 'package:flutter/material.dart';
import 'package:eshi_market/app_payment_methods.dart';
import 'package:eshi_market/app_state_options.dart';
import 'package:eshi_market/helpers/tools.dart';
import 'package:eshi_market/labelconfig.dart';
import 'package:eshi_market/models/cart.dart';
import 'package:eshi_market/models/checkout_session.dart';
import 'package:eshi_market/models/customer_address.dart';
import 'package:eshi_market/widgets/app_loader.dart';
import 'package:eshi_market/widgets/buttons.dart';
import 'package:eshi_market/widgets/woosignal_ui.dart';
import 'package:woosignal/models/response/tax_rate.dart';
import 'package:eshi_market/app_country_options.dart';

class CheckoutConfirmationPage extends StatefulWidget {
  CheckoutConfirmationPage({Key key}) : super(key: key);

  @override
  CheckoutConfirmationPageState createState() =>
      CheckoutConfirmationPageState();
}

class CheckoutConfirmationPageState extends State<CheckoutConfirmationPage> {
  CheckoutConfirmationPageState();

  bool _showFullLoader;

  List<TaxRate> _taxRates;
  TaxRate _taxRate;
  bool _isProcessingPayment;

  @override
  void initState() {
    super.initState();
    _taxRates = [];
    _showFullLoader = true;
    _isProcessingPayment = false;
    if (CheckoutSession.getInstance.paymentType == null) {
      CheckoutSession.getInstance.paymentType = arrPaymentMethods.first;
    }

    _getTaxes();
  }

  void reloadState({bool showLoader}) {
    setState(() {
      _showFullLoader = showLoader ?? false;
    });
  }

  _getTaxes() async {
    int pageIndex = 1;
    bool fetchMore = true;
    while (fetchMore == true) {
      List<TaxRate> tmpTaxRates = await appWooSignal(
          (api) => api.getTaxRates(page: pageIndex, perPage: 100));

      if (tmpTaxRates != null && tmpTaxRates.length > 0) {
        _taxRates.addAll(tmpTaxRates);
      }
      if (tmpTaxRates.length >= 100) {
        pageIndex += 1;
      } else {
        fetchMore = false;
      }
    }

    if (_taxRates == null || _taxRates.length == 0) {
      setState(() {
        _showFullLoader = false;
      });
      return;
    }

    if (CheckoutSession.getInstance.billingDetails == null ||
        CheckoutSession.getInstance.billingDetails.shippingAddress == null) {
      setState(() {
        _showFullLoader = false;
      });
      return;
    }
    String country =
        CheckoutSession.getInstance.billingDetails.shippingAddress.country;
    String state =
        CheckoutSession.getInstance.billingDetails.shippingAddress.state;
    String postalCode =
        CheckoutSession.getInstance.billingDetails.shippingAddress.postalCode;

    Map<String, dynamic> countryMap = appCountryOptions
        .firstWhere((c) => c['name'] == country, orElse: () => null);

    if (countryMap == null) {
      _showFullLoader = false;
      setState(() {});
      return;
    }

    TaxRate taxRate;

    Map<String, dynamic> stateMap;
    if (state != null) {
      stateMap = appStateOptions.firstWhere((c) => c['name'] == state,
          orElse: () => null);
    }

    if (stateMap != null) {
      taxRate = _taxRates.firstWhere(
          (t) =>
              t.country == countryMap["code"] &&
              t.state == stateMap["code"] &&
              t.postcode == postalCode,
          orElse: () => null);

      if (taxRate == null) {
        taxRate = _taxRates.firstWhere(
            (t) =>
                t.country == countryMap["code"] && t.state == stateMap["code"],
            orElse: () => null);
      }
    }

    if (taxRate == null) {
      taxRate = _taxRates.firstWhere(
          (t) => t.country == countryMap["code"] && t.postcode == postalCode,
          orElse: () => null);

      if (taxRate == null) {
        taxRate = _taxRates.firstWhere((t) => t.country == countryMap["code"],
            orElse: () => null);
      }
    }

    if (taxRate != null) {
      _taxRate = taxRate;
    }
    setState(() {
      _showFullLoader = false;
    });
  }

  _actionCheckoutDetails() {
    Navigator.pushNamed(context, "/checkout-details").then((e) {
      setState(() {
        _showFullLoader = true;
      });
      _getTaxes();
    });
  }

  _actionPayWith() {
    Navigator.pushNamed(context, "/checkout-payment-type")
        .then((value) => setState(() {}));
  }

  _actionSelectShipping() {
    CustomerAddress shippingAddress =
        CheckoutSession.getInstance.billingDetails.shippingAddress;
    if (shippingAddress == null || shippingAddress.country == "") {
      showEdgeAlertWith(context,
          title: trans(context, "Oops"),
          desc: trans(context, "Add your shipping details first"),
          icon: Icons.local_shipping);
      return;
    }
    Navigator.pushNamed(context, "/checkout-shipping-type").then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: storeLogo(height: 50),
        centerTitle: true,
      ),
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        minimum: safeAreaDefault(),
        child: !_showFullLoader
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Text(
                      trans(context, "Checkout"),
                      style: Theme.of(context).primaryTextTheme.subtitle1,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: wsBoxShadow(),
                      ),
                      margin: EdgeInsets.only(top: 5, bottom: 5),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            ((CheckoutSession.getInstance.billingDetails != null &&
                                    CheckoutSession.getInstance.billingDetails
                                            .billingAddress !=
                                        null)
                                ? wsCheckoutRow(context,
                                    heading: trans(
                                        context, "Billing/shipping details"),
                                    leadImage: Icon(Icons.home),
                                    leadTitle:
                                        (CheckoutSession.getInstance.billingDetails == null ||
                                                CheckoutSession.getInstance
                                                    .billingDetails.billingAddress
                                                    .hasMissingFields()
                                            ? trans(
                                                context, "Billing address is incomplete")
                                            : CheckoutSession.getInstance
                                                .billingDetails.billingAddress
                                                .addressFull()),
                                    action: _actionCheckoutDetails,
                                    showBorderBottom: true)
                                : wsCheckoutRow(context,
                                    heading:
                                        trans(context, "Billing/shipping details"),
                                    leadImage: Icon(Icons.home),
                                    leadTitle: trans(context, "Add billing & shipping details"),
                                    action: _actionCheckoutDetails,
                                    showBorderBottom: true)),
                            (CheckoutSession.getInstance.paymentType != null
                                ? wsCheckoutRow(context,
                                    heading: trans(context, "Payment method"),
                                    leadImage: Image(
                                      image: AssetImage("assets/images/" +
                                          CheckoutSession.getInstance
                                              .paymentType.assetImage),
                                      width: 70,
                                    ),
                                    leadTitle: CheckoutSession
                                        .getInstance.paymentType.desc,
                                    action: _actionPayWith,
                                    showBorderBottom: true)
                                : wsCheckoutRow(context,
                                    heading: trans(context, "Pay with"),
                                    leadImage: Icon(Icons.payment),
                                    leadTitle: trans(
                                        context, "Select a payment method"),
                                    action: _actionPayWith,
                                    showBorderBottom: true)),
                            app_disable_shipping == true
                                ? null
                                : (CheckoutSession.getInstance.shippingType !=
                                        null
                                    ? wsCheckoutRow(context,
                                        heading:
                                            trans(context, "Shipping selected"),
                                        leadImage: Icon(Icons.local_shipping),
                                        leadTitle: CheckoutSession
                                            .getInstance.shippingType
                                            .getTitle(),
                                        action: _actionSelectShipping)
                                    : wsCheckoutRow(
                                        context,
                                        heading:
                                            trans(context, "Select shipping"),
                                        leadImage: Icon(Icons.local_shipping),
                                        leadTitle: trans(context,
                                            "Select a shipping option"),
                                        action: _actionSelectShipping,
                                      )),
                          ].where((e) => e != null).toList()),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Divider(
                        color: Colors.black12,
                        thickness: 1,
                      ),
                      wsCheckoutSubtotalWidgetFB(
                        title: trans(context, "Subtotal"),
                      ),
                      app_disable_shipping == true
                          ? null
                          : widgetCheckoutMeta(context,
                              title: trans(context, "Shipping fee"),
                              amount:
                                  CheckoutSession.getInstance.shippingType ==
                                          null
                                      ? trans(context, "Select shipping")
                                      : CheckoutSession.getInstance.shippingType
                                          .getTotal(withFormatting: true)),
                      (_taxRate != null
                          ? wsCheckoutTaxAmountWidgetFB(taxRate: _taxRate)
                          : null),
                      wsCheckoutTotalWidgetFB(
                          title: trans(context, "Total"), taxRate: _taxRate),
                      Divider(
                        color: Colors.black12,
                        thickness: 1,
                      ),
                    ].where((e) => e != null).toList(),
                  ),
                  wsPrimaryButton(
                    context,
                    title: _isProcessingPayment
                        ? "PROCESSING..."
                        : trans(context, "CHECKOUT"),
                    action: _isProcessingPayment ? null : _handleCheckout,
                  ),
                ],
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    showAppLoader(),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Text(
                        "${trans(context, "One moment")}...",
                        style: Theme.of(context).primaryTextTheme.subtitle1,
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  _handleCheckout() async {
    if (CheckoutSession.getInstance.billingDetails.billingAddress == null) {
      showEdgeAlertWith(
        context,
        title: trans(context, "Oops"),
        desc: trans(context,
            "Please select add your billing/shipping address to proceed"),
        style: EdgeAlertStyle.WARNING,
        icon: Icons.local_shipping,
      );
      return;
    }

    if (CheckoutSession.getInstance.billingDetails.billingAddress
        .hasMissingFields()) {
      showEdgeAlertWith(
        context,
        title: trans(context, "Oops"),
        desc: trans(context, "Your billing/shipping details are incomplete"),
        style: EdgeAlertStyle.WARNING,
        icon: Icons.local_shipping,
      );
      return;
    }

    if (app_disable_shipping == false &&
        CheckoutSession.getInstance.shippingType == null) {
      showEdgeAlertWith(
        context,
        title: trans(context, "Oops"),
        desc: trans(context, "Please select a shipping method to proceed"),
        style: EdgeAlertStyle.WARNING,
        icon: Icons.local_shipping,
      );
      return;
    }

    if (CheckoutSession.getInstance.paymentType == null) {
      showEdgeAlertWith(
        context,
        title: trans(context, "Oops"),
        desc: trans(context, "Please select a payment method to proceed"),
        style: EdgeAlertStyle.WARNING,
        icon: Icons.payment,
      );
      return;
    }

    if (app_disable_shipping == false &&
        CheckoutSession.getInstance.shippingType.minimumValue != null) {
      String total = await Cart.getInstance.getTotal();
      if (total == null) {
        return;
      }
      double doubleTotal = double.parse(total);
      double doubleMinimumValue =
          double.parse(CheckoutSession.getInstance.shippingType.minimumValue);

      if (doubleTotal < doubleMinimumValue) {
        showEdgeAlertWith(context,
            title: trans(context, "Sorry"),
            desc:
                "${trans(context, "Spend a minimum of")} ${formatDoubleCurrency(total: doubleMinimumValue)} ${trans(context, "for")} ${CheckoutSession.getInstance.shippingType.getTitle()}",
            style: EdgeAlertStyle.INFO,
            duration: 3);
        return;
      }
    }

    if (_isProcessingPayment == true) {
      return;
    }

    setState(() {
      _isProcessingPayment = true;
    });

    CheckoutSession.getInstance.paymentType
        .pay(context, state: this, taxRate: _taxRate);

    Future.delayed(Duration(milliseconds: 5000), () {
      setState(() {
        _isProcessingPayment = false;
      });
    });
  }
}
