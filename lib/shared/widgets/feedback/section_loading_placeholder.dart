import 'package:flutter/material.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';

/// Shown by `HomeScreen` while a section's `AsyncValue` is loading. Mock
/// data resolves instantly today, so this is mostly unexercised — it's the
/// reusable answer to "what does a section look like while real data
/// loads" once a future module replaces a mock `AsyncNotifier.build()` body
/// with a real repository call.
class SectionLoadingPlaceholder extends StatelessWidget {
  const SectionLoadingPlaceholder({super.key, this.height = 120});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: const SizedBox(
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }
}
