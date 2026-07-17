import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';

/// Standard back-button + title row used as [PushedScreenLayout]'s `header`
/// by every pushed screen in this module. Kept separate from
/// [PushedScreenLayout] itself since [SearchScreen] swaps this out for its
/// `Hero`-tagged search bar instead.
class PushedScreenHeader extends StatelessWidget {
  const PushedScreenHeader({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return FadeSlideIn(
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              title,
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
