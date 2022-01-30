import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_puzzle_hack/widgets/isometric/custom_mouse_region.dart';
import 'package:flutter_puzzle_hack/widgets/sliding_puzzle/isometric_sliding_puzzle.dart';

const _angle = -30 * pi / 180;

class IsometricButton extends StatefulWidget {
  const IsometricButton({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  final IconData icon;
  final VoidCallback onPressed;

  @override
  State<IsometricButton> createState() => _IsometricButtonState();
}

class _IsometricButtonState extends State<IsometricButton> {
  bool isHover = false;
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: (details) {
        setState(() {
          isPressed = true;
        });
      },
      onTapUp: (details) {
        setState(() {
          isPressed = false;
        });
      },
      child: CustomMouseRegion(
        onEnter: (_) {
          setState(() {
            isHover = true;
          });
        },
        onExit: (_) {
          setState(() {
            isHover = false;
            isPressed = false;
          });
        },
        child: AnimatedScale(
          scale: isPressed ? 0.5 : 1.0,
          duration: const Duration(milliseconds: 500),
          curve: ElasticOutCurve(1),
          child: Stack(
            children: [
              AnimatedIsometricTile(
                top:
                    isHover ? const Color(0xFF66BB6A) : const Color(0xFF8D6E63),
                right: const Color(0xFF795548),
                left: const Color(0xFF6D4C41),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOut,
              ),
              Positioned.fill(
                child: FractionalTranslation(
                  translation: const Offset(0, -0.35),
                  child: FractionallySizedBox(
                    alignment: Alignment.bottomLeft,
                    widthFactor: 0.58,
                    heightFactor: 0.4,
                    child: Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: Transform(
                          transform: Matrix4.rotationZ(-_angle) *
                              Matrix4.skewX(-_angle),
                          child: FittedBox(
                            child: Icon(
                              widget.icon,
                              color: const Color(0x44000000),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
