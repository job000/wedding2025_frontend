// lib/shared/widgets/animated_button.dart

import 'package:flutter/material.dart';
import '../../core/theme/custom_colors.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;

  const AnimatedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.icon,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
    if (isHovered) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Flexible( // Lagt til for å unngå overflow
      child: MouseRegion(
        onEnter: (_) => _handleHover(true),
        onExit: (_) => _handleHover(false),
        child: GestureDetector(
          onTapDown: (_) => _controller.forward(),
          onTapUp: (_) => _controller.reverse(),
          onTapCancel: () => _controller.reverse(),
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) => Transform.scale(
              scale: _scaleAnimation.value,
              child: child,
            ),
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _isHovered
                      ? [
                          widget.backgroundColor?.withOpacity(0.9) ?? CustomColors.navy,
                          widget.backgroundColor?.withOpacity(0.7) ?? CustomColors.navy.withOpacity(0.8),
                        ]
                      : [
                          widget.backgroundColor ?? CustomColors.navy,
                          widget.backgroundColor?.withOpacity(0.9) ?? CustomColors.navy.withOpacity(0.9),
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: (widget.backgroundColor ?? CustomColors.navy).withOpacity(0.3),
                    blurRadius: _isHovered ? 12 : 8,
                    offset: const Offset(0, 4),
                    spreadRadius: _isHovered ? 2 : 0,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.isLoading ? null : widget.onPressed,
                  borderRadius: BorderRadius.circular(28),
                  splashColor: Colors.white.withOpacity(0.1),
                  highlightColor: Colors.white.withOpacity(0.05),
                  child: Center(
                    child: widget.isLoading
                        ? _buildLoadingIndicator()
                        : _buildButtonContent(),
                  ),
                ),
              ),
            ).animate(
              effects: [
                FadeEffect(duration: 300.ms),
                SlideEffect(begin: const Offset(0, 0.1), end: const Offset(0, 0)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      width: 24,
      height: 24,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        valueColor: AlwaysStoppedAnimation<Color>(
          widget.textColor ?? Colors.white,
        ),
      ),
    ).animate(
      effects: [
        RotateEffect(
          begin: 0.0,
          end: 1.0,
          duration: 1000.ms,
          curve: Curves.linear,
        ),
      ],
    );
  }

  Widget _buildButtonContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.icon != null) ...[
          Icon(
            widget.icon,
            color: widget.textColor ?? Colors.white,
            size: 20,
          ),
          const SizedBox(width: 8),
        ],
        Text(
          widget.text,
          style: TextStyle(
            color: widget.textColor ?? Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    ).animate(
      effects: [
        ScaleEffect(
          begin: const Offset(0.95, 0.95),
          end: const Offset(1, 1),
          duration: 200.ms,
        ),
      ],
    );
  }
}
