import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/features/onboarding/data/onboarding_pages_data.dart';
import 'package:lifeos/features/onboarding/presentation/providers/onboarding_providers.dart';

void main() {
  test('starts at page 0', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(onboardingPageIndexProvider), 0);
  });

  test('next() advances up to the last page and no further', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(onboardingPageIndexProvider.notifier);

    for (var i = 0; i < kOnboardingPages.length + 2; i++) {
      notifier.next();
    }

    expect(
      container.read(onboardingPageIndexProvider),
      kOnboardingPages.length - 1,
    );
  });

  test('previous() retreats down to page 0 and no further', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(onboardingPageIndexProvider.notifier);

    notifier.previous();
    expect(container.read(onboardingPageIndexProvider), 0);
  });

  test('isLastPage is true only on the final page', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(onboardingPageIndexProvider.notifier);

    expect(notifier.isLastPage, isFalse);

    for (var i = 0; i < kOnboardingPages.length - 1; i++) {
      notifier.next();
    }

    expect(notifier.isLastPage, isTrue);
  });
}
