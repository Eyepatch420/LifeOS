import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Enforces `docs/architecture_principles.md`'s Golden Rule and
/// Architecture Constraint 6 (removability): no feature may import another
/// feature's `data/`, `domain/entities/`, or `presentation/screens/`.
/// Allowed cross-feature imports are exactly the five contract seams —
/// dashboard summary providers (`domain/contracts/` +
/// `presentation/providers/*_dashboard_provider.dart`), search/notification
/// contributor *interfaces* (not implementations), and anything under
/// `core/`/`shared/`/`config/` (not a feature).
void main() {
  test('no feature imports another feature\'s internals directly', () {
    final featuresDir = Directory('lib/features');
    if (!featuresDir.existsSync()) {
      fail('lib/features not found — run tests from the project root.');
    }

    final violations = <String>[];
    final featureDirs = featuresDir
        .listSync()
        .whereType<Directory>()
        .map((d) => d.path.split(Platform.pathSeparator).last)
        .toSet();

    for (final entry in featuresDir.listSync(recursive: true)) {
      if (entry is! File || !entry.path.endsWith('.dart')) continue;
      if (entry.path.contains(
        '${Platform.pathSeparator}test${Platform.pathSeparator}',
      )) {
        continue;
      }

      final ownerFeature = _featureOwning(entry.path, featuresDir.path);
      if (ownerFeature == null) continue;

      final lines = entry.readAsLinesSync();
      for (final line in lines) {
        final match = RegExp(
          r'''^import\s+['"]package:lifeos/features/([^/]+)/(.+?)['"]''',
        ).firstMatch(line.trim());
        if (match == null) continue;

        final importedFeature = match.group(1)!;
        final importedPath = match.group(2)!;
        if (importedFeature == ownerFeature) continue;
        if (!featureDirs.contains(importedFeature)) continue;

        final isAllowedSeam =
            importedPath.startsWith('domain/contracts/') ||
            importedPath.endsWith('_dashboard_provider.dart') ||
            importedPath == 'domain/search_contributor.dart' ||
            importedPath == 'domain/notification_contributor.dart';

        final isForbidden =
            importedPath.startsWith('data/') ||
            importedPath.startsWith('domain/entities/') ||
            importedPath.startsWith('presentation/screens/');

        if (isForbidden && !isAllowedSeam) {
          violations.add(
            '${entry.path}: imports feature "$importedFeature"\'s '
            '"$importedPath" — only dashboard summary providers, contract '
            'interfaces, or shared services may cross feature boundaries.',
          );
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason: violations.isEmpty ? null : violations.join('\n'),
    );
  });
}

/// The feature name owning [filePath] (the first path segment under
/// `lib/features/`), or null if [filePath] isn't inside `lib/features/` at
/// all (shouldn't happen given the caller only walks that directory, but
/// keeps this function total).
String? _featureOwning(String filePath, String featuresDirPath) {
  final relative = filePath.substring(featuresDirPath.length + 1);
  final segments = relative.split(Platform.pathSeparator);
  return segments.isEmpty ? null : segments.first;
}
