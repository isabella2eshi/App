import 'package:flutter/widgets.dart';
import 'package:eshi_market/helpers/data/order_wc.dart';
import 'package:eshi_market/helpers/tools.dart';
import 'package:eshi_market/pages/checkout_confirmation.dart';
import 'package:woosignal/models/payload/order_wc.dart';
import 'package:woosignal/models/response/order.dart';
import 'package:woosignal/models/response/tax_rate.dart';

yenePay(context,
    {@required CheckoutConfirmationPageState state, TaxRate taxRate}) async {
  // TODO: Handle Check out here.

  OrderWC orderWC = await buildOrderWC(taxRate: taxRate, markPaid: true);

  // CREATES ORDER IN WOOCOMMERCE
  Order order = await appWooSignal((api) => api.createOrder(orderWC));

  // CHECK IF ORDER IS NULL
  if (order != null) {
    Navigator.pushNamed(context, "/checkout-status", arguments: order);
  } else {
    showEdgeAlertWith(
      context,
      title: trans(context, "Error"),
      desc: trans(context,
          trans(context, "Something went wrong, please contact our store")),
    );
    state.reloadState(showLoader: false);
  }
}
