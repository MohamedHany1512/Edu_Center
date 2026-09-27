import 'package:flutter/material.dart';

/// Themed separator used between the rows of a settings card.
class CustomDivider extends StatelessWidget {
  const CustomDivider({
    super.key,
    this.color,
    this.thickness = 1,
    this.indent = 0,
    this.endIndent = 0,
  });

  final Color? color;
  final double thickness;
  final double indent;
  final double endIndent;

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: color,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
    );
  }
}