import 'package:flutter/material.dart';

class AppDialog extends StatelessWidget {
  const AppDialog({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      clipBehavior: Clip.antiAlias,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: child,
    );
  }

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    bool barrierDismissible = true,
  }) {
    return showGeneralDialog<T>(
      transitionBuilder: (context, animation, secondaryAnimation, widget) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: const ElasticOutCurve(0.9),
        );

        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1).animate(curvedAnimation),
          child: FadeTransition(
            opacity: curvedAnimation,
            child: widget,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
      barrierDismissible: barrierDismissible,
      barrierLabel: '',
      barrierColor: const Color(0x66000000),
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return AppDialog(
          child: child,
        );
      },
    );
  }
}
