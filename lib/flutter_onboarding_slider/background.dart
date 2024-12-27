import 'package:flutter/material.dart';
import 'background_image.dart';

class Background extends StatelessWidget {
  final Widget child;
  final int totalPage;
  final List<Widget> background;
  final double speed;
  final double imageVerticalOffset;
  final double imageHorizontalOffset;
  final bool centerBackground;

  // Constructor dengan validasi input dan parameter default
  Background({
    required this.child,
    required this.totalPage,
    required this.background,
    this.speed = 1.0,
    this.imageVerticalOffset = 0.0,
    this.imageHorizontalOffset = 0.0,
    this.centerBackground = false,
  }) : assert(
          background.length == totalPage,
          'Jumlah elemen background harus sama dengan totalPage.',
        );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        for (int i = 0; i < totalPage; i++)
          BackgroundImage(
            centerBackground: centerBackground,
            imageHorizontalOffset: imageHorizontalOffset,
            imageVerticalOffset: imageVerticalOffset,
            id: totalPage - i,
            speed: speed,
            background: background[totalPage - i - 1],
          ),
        child,
      ],
    );
  }
}
