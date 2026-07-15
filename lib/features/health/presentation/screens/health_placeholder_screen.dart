import 'package:flutter/material.dart';
import 'package:lifeos/shared/widgets/scaffolds/placeholder_scaffold.dart';

class HealthPlaceholderScreen extends StatelessWidget {
  const HealthPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScaffold(
      title: 'Health',
      icon: Icons.favorite_outline,
    );
  }
}
