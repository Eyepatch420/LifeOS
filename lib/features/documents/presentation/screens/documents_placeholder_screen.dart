import 'package:flutter/material.dart';
import 'package:lifeos/shared/widgets/scaffolds/placeholder_scaffold.dart';

class DocumentsPlaceholderScreen extends StatelessWidget {
  const DocumentsPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScaffold(
      title: 'Documents',
      icon: Icons.folder_outlined,
    );
  }
}
