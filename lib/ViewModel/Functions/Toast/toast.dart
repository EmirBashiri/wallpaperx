import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomToast {
  final FToast _fToast = FToast();
  // Call this void in each screen you want show toast inside it
  void initializeToast(BuildContext context) {
    _fToast.init(context);
  }

  // Call this void to show toast
  void showToast(
      {required Widget child,
      ToastGravity? toastGravity,
      Duration toastDuration = const Duration(seconds: 2),
      Duration fadeDuration = const Duration(milliseconds: 350)}) {
    _fToast.removeQueuedCustomToasts();
    _fToast.showToast(
        child: child,
        toastDuration: toastDuration,
        gravity: toastGravity,
        fadeDuration: fadeDuration);
  }
}
