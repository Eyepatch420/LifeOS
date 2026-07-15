import 'package:flutter/material.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';

/// "Coming soon" stub used by every non-Home tab in Module 1. Parameterized
/// so it's one shared widget, not 4 bespoke screens.
class PlaceholderScaffold extends StatelessWidget {
  const PlaceholderScaffold({
    required this.title,
    required this.icon,
    super.key,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 56, color: context.colorScheme.primary),
              const SizedBox(height: 16),
              Text(title, style: context.textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(
                'Coming soon',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
