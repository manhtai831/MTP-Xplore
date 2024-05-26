import 'package:flutter/material.dart';

class BaseButton extends StatelessWidget {
  const BaseButton({Key? key, this.onPressed, this.child}) : super(key: key);
  final VoidCallback? onPressed;
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      minWidth: 0,
      padding: EdgeInsets.zero,
      height: 0,
      child: child,
    );
  }
}
