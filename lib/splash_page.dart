import 'package:flutter/material.dart';

class DibsLoadingAnimation extends StatefulWidget {
  const DibsLoadingAnimation({super.key});

  @override
  State<DibsLoadingAnimation> createState() => _DibsLoadingAnimationState();
}

class _DibsLoadingAnimationState extends State<DibsLoadingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Text(
          'Dibs',
          style: TextStyle(
            fontSize: 40,
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: Colors.blue.withOpacity(_controller.value),
                offset: const Offset(0, 0),
              ),
            ],
          ),
        );
      },
    );
  }
}
