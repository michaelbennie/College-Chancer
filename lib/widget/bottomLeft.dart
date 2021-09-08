import 'package:flutter/material.dart';

Widget bottomLeft(Widget widget) {
  return Align(
    alignment: FractionalOffset.bottomLeft,
    child: Padding(padding: EdgeInsets.only(left: 25.0), child: widget),
  );
}
