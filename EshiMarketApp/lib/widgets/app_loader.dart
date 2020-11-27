import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';

Widget showAppLoader() {
  return SpinKitDoubleBounce(color: HexColor("#393318"));
}
