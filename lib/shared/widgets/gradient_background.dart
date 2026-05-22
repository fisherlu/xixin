import "package:flutter/material.dart";

class GradientBackground extends StatelessWidget {
  final List<Color> colors;
  final Widget? child;
  final Alignment begin;
  final Alignment end;

  const GradientBackground({
    super.key,
    required this.colors,
    this.child,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: colors,
        ),
      ),
      child: child,
    );
  }
}
