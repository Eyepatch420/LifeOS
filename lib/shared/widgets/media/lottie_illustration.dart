import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Consistent sizing/repeat/fit wrapper around [Lottie.asset] so features
/// never configure these options ad hoc.
class LottieIllustration extends StatelessWidget {
  const LottieIllustration({
    required this.assetPath,
    super.key,
    this.size = 260,
  });

  final String assetPath;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Lottie.asset(assetPath, repeat: true, fit: BoxFit.contain),
    );
  }
}
