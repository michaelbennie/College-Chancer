import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';

Widget loadingPage(String text, TextStyle style) {
  return Center(
    child: JumpingText(
      "Loading " + text + "...",
      style: style,
    ),
  );
}
