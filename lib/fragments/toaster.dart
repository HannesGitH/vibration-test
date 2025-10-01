import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart' as FT;

showToast(
  String message, {
  BuildContext? context,
}) {
  if (context == null)
    return FT.Fluttertoast.showToast(
      msg: message,
      toastLength: FT.Toast.LENGTH_SHORT,
      gravity: FT.ToastGravity.CENTER,
    );
  final toast = FT.FToast();
  toast.init(context);
  toast.showToast(
    child: Toast(message: message),
  );
}

class Toast extends StatelessWidget {
  const Toast({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.info_rounded),
              const SizedBox(
                width: 12.0,
              ),
              Text(message),
            ],
          ),
        ),
      ),
    );
  }
}
