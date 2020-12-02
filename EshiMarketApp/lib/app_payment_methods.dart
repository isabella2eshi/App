import 'package:eshi_market/helpers/tools.dart';
import 'package:eshi_market/models/payment_type.dart';
import 'package:eshi_market/providers/cash_on_delivery.dart';
import 'package:eshi_market/providers/razor_pay.dart';
import 'package:eshi_market/providers/stripe_pay.dart';
import 'package:eshi_market/providers/yenepay.dart';

// Payment methods available for uses in the app

List<PaymentType> arrPaymentMethods = [
  addPayment(
    PaymentType(
      id: 1,
      name: "Stripe",
      desc: "Debit or Credit Card",
      assetImage: "dark_powered_by_stripe.png",
      pay: stripePay,
    ),
  ),
  addPayment(
    PaymentType(
      id: 2,
      name: "CashOnDelivery",
      desc: "Cash on delivery",
      assetImage: "cash_on_delivery.jpeg",
      pay: cashOnDeliveryPay,
    ),
  ),
  addPayment(
    PaymentType(
      id: 3,
      name: "RazorPay",
      desc: "Debit or Credit Card",
      assetImage: "razorpay.png",
      pay: razorPay,
    ),
  ),
  addPayment(
    PaymentType(
      id: 4,
      name: "YenePay",
      desc: "Yene Pay (TESTING)",
      assetImage: "yenepay.png",
      pay: yenePay,
    ),
  ),
].where((e) => e != null).toList();
