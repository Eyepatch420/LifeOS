import 'package:flutter/material.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';

/// Title + optional trailing "View all" link — reused across Home and
/// every future module's list sections.
class SectionHeader extends StatelessWidget {
  const SectionHeader({required this.title, super.key, this.onViewAll});

  final String title;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (onViewAll != null)
          TextButton(onPressed: onViewAll, child: const Text('View all')),
      ],
    );
  }
}
