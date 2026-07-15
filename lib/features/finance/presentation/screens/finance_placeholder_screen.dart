import 'package:flutter/material.dart';
import 'package:lifeos/shared/widgets/scaffolds/placeholder_scaffold.dart';

class FinancePlaceholderScreen extends StatelessWidget {
  const FinancePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScaffold(
      title: 'Finance',
      icon: Icons.account_balance_wallet_outlined,
    );
  }
}
