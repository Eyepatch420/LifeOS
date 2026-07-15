import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/core/constants/app_constants.dart';
import 'package:lifeos/features/splash/presentation/widgets/splash_logo_animation.dart';
import 'package:lifeos/theme/app_theme.dart';
import 'package:lifeos/theme/workspace_theme_data.dart';

void main() {
  testWidgets('SplashLogoAnimation renders the tagline', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.build(
            Brightness.light,
            workspaceThemeFor(WorkspaceIds.home),
          ),
          home: const Scaffold(body: SplashLogoAnimation()),
        ),
      ),
    );

    await tester.pump();
    expect(find.text(AppConstants.appTagline), findsOneWidget);

    // Let the animation controller finish so no pending timers leak into
    // the next test.
    await tester.pumpAndSettle();
  });
}
