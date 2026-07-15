import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Selected bottom-nav tab index (0–4). Drives both the
/// `StatefulShellRoute` branch and, via `AppShell`, the active workspace
/// theme together.
class BottomNavIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int index) => state = index;
}

final bottomNavIndexProvider = NotifierProvider<BottomNavIndexNotifier, int>(
  BottomNavIndexNotifier.new,
);
