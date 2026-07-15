import 'package:flutter/material.dart';

/// Base scaffold for any tab hosted by the floating bottom nav: the tab's
/// [body] scrolls beneath the nav, with enough bottom padding reserved so
/// content never sits under the floating pill.
class FloatingPageLayout extends StatelessWidget {
  const FloatingPageLayout({required this.body, super.key});

  final Widget body;

  /// Reserved space below scrollable content so it never sits under the
  /// floating nav pill. Kept as a named constant here (not computed from
  /// the nav's own height) since the nav's height is itself a small,
  /// bounded constant — see `FloatingBottomNav`.
  static const double navClearance = 96;

  @override
  Widget build(BuildContext context) {
    return Scaffold(extendBody: true, body: body);
  }
}
