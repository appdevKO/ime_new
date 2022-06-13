import 'dart:ui';

import 'package:flutter/material.dart';

void bottomSheet(context, widget) {
  showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      context: context,
      builder: (bc) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: widget,
        );
      });
}
