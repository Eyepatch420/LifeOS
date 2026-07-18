import 'package:flutter/material.dart';
import 'package:lifeos/core/animations/curves.dart';
import 'package:lifeos/core/animations/durations.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';

/// Stable ids for the built-in avatar set. No custom avatar art exists yet
/// (see docs/future_work.md) — Module 1 uses a small set of colored
/// icon-avatars distinguished by [avatarAssetPath], which for now is just
/// this id string rather than a real asset path.
const List<String> kAvatarIds = [
  'fox',
  'owl',
  'cat',
  'panda',
  'bear',
  'rabbit',
];

const Map<String, IconData> _avatarIcons = {
  'fox': Icons.pets,
  'owl': Icons.nightlight_round,
  'cat': Icons.emoji_nature,
  'panda': Icons.savings,
  'bear': Icons.forest,
  'rabbit': Icons.cruelty_free,
};

/// Looks up the icon for a stored `avatarAssetPath` id, falling back to a
/// generic person icon for an unset/unrecognized id.
IconData avatarIconFor(String? avatarId) =>
    _avatarIcons[avatarId] ?? Icons.person;

/// Grid of selectable local avatar options with an animated selection ring.
class AvatarPickerGrid extends StatelessWidget {
  const AvatarPickerGrid({
    required this.selectedId,
    required this.onSelected,
    super.key,
  });

  final String? selectedId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        for (final id in kAvatarIds)
          _AvatarOption(
            id: id,
            selected: id == selectedId,
            onTap: () => onSelected(id),
          ),
      ],
    );
  }
}

class _AvatarOption extends StatelessWidget {
  const _AvatarOption({
    required this.id,
    required this.selected,
    required this.onTap,
  });

  final String id;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme.primary;
    return Semantics(
      button: true,
      selected: selected,
      label: 'Avatar $id',
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppDurations.fast,
          curve: AppCurves.easeOutCubic,
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: selected
                ? color.withValues(alpha: 0.16)
                : context.colorScheme.surfaceContainerHigh,
            border: Border.all(
              color: selected ? color : Colors.transparent,
              width: 2.5,
            ),
          ),
          child: Icon(
            _avatarIcons[id],
            color: selected ? color : context.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
