import 'package:flutter/material.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';

/// Generic rounded card shell used by Up Next / Habit Streaks / Recent
/// Notes / My Lists — and any future module's list-style card.
class SectionCard extends StatelessWidget {
  const SectionCard({required this.child, super.key, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}
