import 'package:flutter/material.dart';

class DotSpinner extends StatefulWidget {
  final double size;
  final Color color;
  final Duration speed;

  const DotSpinner({
    super.key,
    this.size = 50.0,
    this.color = const Color(0xFF183153),
    // Slower animation for better UX
    this.speed = const Duration(milliseconds: 1200),
  });

  @override
  State<DotSpinner> createState() => _DotSpinnerState();
}

class _DotSpinnerState extends State<DotSpinner> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.speed,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildSquare(int index) {
    final positions = [
      [-1, -1], [0, -1], [1, -1],
      [-1, 0], [0, 0], [1, 0],
      [-1, 1], [0, 1], [1, 1],
    ];

    // Slower delay for smoother transition
    final delay = (index * 0.08).clamp(0.0, 0.7);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final animation = Tween(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(
              delay,
              (delay + 0.3).clamp(0.0, 1.0),
              curve: Curves.easeInOut,
            ),
          ),
        );

        return Positioned(
          left: widget.size * 0.5 + (positions[index][0] * widget.size * 0.3),
          top: widget.size * 0.5 + (positions[index][1] * widget.size * 0.3),
          child: Opacity(
            opacity: animation.value,
            child: Container(
              width: widget.size * 0.2,
              height: widget.size * 0.2,
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        children: List.generate(9, (index) => _buildSquare(index)),
      ),
    );
  }
}
