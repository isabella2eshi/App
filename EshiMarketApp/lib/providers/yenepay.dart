import 'dart:convert';

import 'package:eshi_market/models/cart_line_item.dart';
import 'package:flutter/widgets.dart';
import 'package:eshi_market/helpers/data/order_wc.dart';
import 'package:eshi_market/helpers/tools.dart';
import 'package:eshi_market/pages/checkout_confirmation.dart';
import 'package:woosignal/models/payload/order_wc.dart';
import 'package:woosignal/models/response/order.dart';
import 'package:woosignal/models/response/tax_rate.dart';
import 'package:http/http.dart' as http;
import 'package:eshi_market/labelconfig.dart';
import 'dart:developer' as developer;

yenePay(context,
    {@required CheckoutConfirmationPageState state, TaxRate taxRate}) async {
  // TODO: Handle Check out here.
  await checkout(taxRate, (total, billingDetails, cart) async {
    var url = 'https://testapi.yenepay.com/api/urlgenerate/getcheckouturl/';
    List<Map<String, Object>> items = new List<Map<String, Object>>();
    List<CartLineItem> cartitems = await cart.getCart();
    for (var cartitem in cartitems) {
      var item = {
        "itemName": cartitem.name,
        "unitPrice": cartitem.subtotal,
        "quantity": cartitem.quantity,
      };
      items.add(item);
    }
    var postData = {
      "process": "Express",
      "merchantId": merchant_id,
      "items": items,
    };
    var headers = <String, String>{'Content-Type': 'application/json'};
    var body = jsonEncode(postData);

    var response = await http.post(url, headers: headers, body: body);
    var checkouturl = jsonDecode(response.body)['result'];
  });

  // OrderWC orderWC = await buildOrderWC(taxRate: taxRate, markPaid: true);

  // // CREATES ORDER IN WOOCOMMERCE
  // Order order = await appWooSignal((api) => api.createOrder(orderWC));

  //  // CHECK IF ORDER IS NULL
  // if (order != null) {
  //   Navigator.pushNamed(context, "/checkout-status", arguments: order);
  // } else {
  //   showEdgeAlertWith(
  //     context,
  //     title: trans(context, "Error"),
  //     desc: trans(context,
  //         trans(context, "Something went wrong, please contact our store")),
  //   );
  state.reloadState(showLoader: false);
}
