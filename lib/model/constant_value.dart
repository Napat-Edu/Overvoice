import 'package:flutter/material.dart';

class ConstantValue {
  double getScreenWidth(context) {
    return MediaQuery.of(context).size.width;
  }

  double getScreenHeight(context) {
    return MediaQuery.of(context).size.height;
  }
}
