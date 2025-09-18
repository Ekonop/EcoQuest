import 'package:flutter/material.dart';
import 'package:liquid_glass/liquid_glass.dart';

class EcoGlassCard extends StatefulWidget {
  final Widget child;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Gradient? gradient;
  final bool interactive;

  const EcoGlassCard({
    super.key,
    required this.child,
    this.height,
    this.width,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 20,
    this.gradient,
    this.interactive = false,
  });

  @override
  State<EcoGlassCard> createState() => _EcoGlassCardState();
}

class _EcoGlassCardState extends State<EcoGlassCard> with SingleTickerProviderStateMixin {
  late double _scale;
  static const _pressedScale = 0.97;

  void _onTapDown(TapDownDetails d) => setState(() => _scale = _pressedScale);
  void _onTapCancel() => setState(() => _scale = 1.0);
  void _onTapUp(TapUpDetails d) => setState(() => _scale = 1.0);

  @override
  void initState() {
    super.initState();
    _scale = 1.0;
  }

  @override
  Widget build(BuildContext context) {
    final br = BorderRadius.circular(widget.borderRadius);
    final brightness = Theme.of(context).brightness;
    final bool dark = brightness == Brightness.dark;
    final Gradient effective = widget.gradient ?? LinearGradient(
      colors: dark
          ? [Colors.white.withOpacity(0.12), Colors.white.withOpacity(0.04)]
          : [Colors.white.withOpacity(0.25), Colors.white.withOpacity(0.10)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    Widget card = LiquidGlass(
      blur: 18,
      opacity: dark ? 0.16 : 0.20,
      borderRadius: br,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            borderRadius: br,
            border: Border.all(color: Colors.white.withOpacity(dark ? 0.18 : 0.28), width: 1),
            gradient: effective,
          ),
          padding: widget.padding,
          child: DefaultTextStyle.merge(
            style: TextStyle(
              color: dark ? Colors.white.withOpacity(0.92) : Colors.white,
              shadows: [
                Shadow(
                  offset: const Offset(0, 1),
                  blurRadius: 2,
                  color: Colors.black.withOpacity(dark ? 0.6 : 0.25),
                ),
              ],
            ),
            child: widget.child,
          ),
        ),
      ),
    );

    if (widget.interactive) {
      card = GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: card,
      );
    }

    return card;
  }
}
