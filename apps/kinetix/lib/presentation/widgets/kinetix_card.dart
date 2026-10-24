import 'package:flutter/material.dart';
import '../../core/theme/neumorphic_decorations.dart';

class KinetixCard extends StatelessWidget {
  final Widget child;
  final NeumorphicStyle style;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final VoidCallback? onTap;

  const KinetixCard({
    super.key,
    required this.child,
    this.style = NeumorphicStyle.raised,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderRadius = 16.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      margin: margin,
      padding: padding,
      decoration: NeumorphicDecorations.decoration(
        style: style,
        borderRadius: borderRadius,
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: content);
    }
    return content;
  }
}
