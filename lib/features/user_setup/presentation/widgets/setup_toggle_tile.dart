import 'package:flutter/material.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';

/// Icon + label + description + Switch — used for the daily-reminder and
/// biometric-lock toggles in User Setup. Generic enough to be reused by a
/// future Settings module (see docs/future_work.md).
class SetupToggleTile extends StatelessWidget {
  const SetupToggleTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      toggled: value,
      label: title,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(icon, color: context.colorScheme.primary),
        title: Text(title),
        subtitle: Text(
          subtitle,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: Switch(value: value, onChanged: onChanged),
      ),
    );
  }
}
