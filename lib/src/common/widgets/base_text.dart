import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BaseText extends StatelessWidget {
  double? fontSize;
  FontWeight? fontWeight;
  Color? color;
  String? title;
  TextOverflow? overflow;
  int? maxLines;

  BaseText({
    super.key,
    this.fontSize = 14,
    this.fontWeight = FontWeight.normal,
    this.color,
    this.title,
    this.overflow,
    this.maxLines,
  });
  
  BaseText.bold({
    super.key,
    this.fontSize = 14,
    this.fontWeight = FontWeight.bold,
    this.color,
    this.title,
    this.overflow,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title ?? '',
      overflow: overflow,
      maxLines: maxLines,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color,
            
          ),
    );
  }
}
