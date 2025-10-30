import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

toastMsgCancel() {
  Fluttertoast.cancel();
}

toastMsg(String value) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(
    msg: value,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.grey,
    textColor: Colors.white,
    fontSize: 12.0,
  );
}

void logInfo({required String name, required String msg}) {
  log('\x1B[33m$msg\x1B[0m', name: '\x1B[37m$name\x1B[0m');
}

/*String logModelList({ dynamic list}) {
  return jsonEncode(list.map((e) => e.toMap()).toList());
}*/
void logSuccess({required String name, required String msg}) {
  log('\x1B[32m$msg\x1B[0m', name: '\x1B[37m$name\x1B[0m');
}

void logError({required String name, required String msg}) {
  // Try to infer caller name if not provided
  String caller = name;

  // Tag logs with caller info
  final logTag = '[ERROR][$caller]';

  print('$logTag ❌ ExceptionAt: $name');
}
