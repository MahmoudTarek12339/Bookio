import 'package:flutter/material.dart';

Widget heroWidget(String tag, Widget child) {
  return Hero(
    tag: tag,
    child: Material(
      animationDuration: const Duration(milliseconds: 1500),
      type: MaterialType.transparency,
      color: Colors.transparent,
      child: child),
  );
}
