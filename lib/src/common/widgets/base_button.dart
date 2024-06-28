import 'package:flutter/material.dart';

class BaseButton extends StatelessWidget {
  const BaseButton({
    super.key,
    this.onPressed,
    this.child,
    this.onDoubleTap,
    this.borderRadius,
  });
  final VoidCallback? onPressed;
  final VoidCallback? onDoubleTap;
  final Widget? child;
  final BorderRadiusGeometry? borderRadius;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: onDoubleTap,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 0,
          focusNode: FocusNode(
            skipTraversal: true,
          ),
          padding: EdgeInsets.zero,
          height: 0,
          child: child,
        ),
      ),
    );
  }
}
