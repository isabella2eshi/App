//
//  LabelCore
//  Label StoreMAX
//
//  Created by Anthony Gordon.
//  2020, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'dart:ui';

/*
 Developer Notes

 SUPPORT EMAIL - support@woosignal.com
 VERSION - 2.4.0
 https://woosignal.com
 */

/*<! ------ CONFIG ------!>*/

const app_name = "Eshi Market";

const app_key =
    "app_3b043acfe50e57ea20fcc194c71eb0d449b77de6c6ecc0a709395af2bc9b";

// Your App key from WooSignal
// link: https://woosignal.com/dashboard/apps

const app_logo_url =
    "https://eshimarket.com/wp-content/uploads/2020/10/ESHI-MARKET3.png";

const app_terms_url = "https://eshimarket.com/terms-and-conditions";
const app_privacy_url = "https://eshimarket.com/privacy-policy";

/*<! ------ APP SETTINGS ------!>*/

const app_currency_symbol = "Birr";
const app_currency_iso = "etb";

const app_products_prices_include_tax = true;

const app_disable_shipping = false;

const Locale app_locale = Locale('en');

const List<Locale> app_locales_supported = [Locale('en')];
// If you want to localize the app, add the locale above
// then create a new lang json file using keys from en.json
// e.g. lang/es.json

/*<! ------ PAYMENT GATEWAYS ------!>*/

// Available: "Stripe", "CashOnDelivery", "RazorPay"
// Add the method to the array below e.g. ["Stripe", "CashOnDelivery"]

const app_payment_methods = ["CashOnDelivery"];

/*<! ------ STRIPE (OPTIONAL) ------!>*/

// Your StripeAccount key from WooSignal
// link: https://woosignal.com/dashboard

/*<! ------ WP LOGIN (OPTIONAL) ------!>*/

// Allows customers to login/register, view account, purchase items as a user.
// #1 Install the "WP JSON API" plugin on WordPress via https://woosignal.com/plugins/wordpress/wpapp-json-api
// #2 Next activate the plugin on your WordPress and enable "use_wp_login = true"
// link: https://woosignal.com/dashboard/plugins

const use_wp_login = true;
const app_base_url = "https://eshimarket.com";
const app_forgot_password_url =
    "https://eshimarket.com/my-account-2/lost-password/";
const app_wp_api_path = "/wp-json"; // By default "/wp-json" should work

/*<! ------ DEBUGGER ENABLED ------!>*/

const app_debug = true;
