import 'package:flutter/material.dart';
import 'package:lifeos/shared/widgets/scaffolds/placeholder_scaffold.dart';

class RemindersPlaceholderScreen extends StatelessWidget {
  const RemindersPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScaffold(
      title: 'Reminders',
      icon: Icons.notifications_outlined,
    );
  }
}
