import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/features/onboarding/domain/models/onboarding_accent.dart';

void main() {
  const blue = OnboardingAccent(
    primary: Colors.blue,
    gradient: [Colors.blue, Colors.lightBlue],
  );
  const green = OnboardingAccent(
    primary: Colors.green,
    gradient: [Colors.green, Colors.lightGreen],
  );

  test('lerp at t=0 returns the start accent colors', () {
    final result = OnboardingAccent.lerp(blue, green, 0);
    expect(result.primary.toARGB32(), Colors.blue.toARGB32());
  });

  test('lerp at t=1 returns the end accent colors', () {
    final result = OnboardingAccent.lerp(blue, green, 1);
    expect(result.primary.toARGB32(), Colors.green.toARGB32());
  });

  test('lerp at t=0.5 interpolates the primary color', () {
    final result = OnboardingAccent.lerp(blue, green, 0.5);
    expect(result.primary, Color.lerp(Colors.blue, Colors.green, 0.5));
  });

  test('lerp interpolates every color in the gradient list', () {
    final result = OnboardingAccent.lerp(blue, green, 0.5);
    expect(result.gradient, hasLength(2));
    expect(result.gradient.first, Color.lerp(Colors.blue, Colors.green, 0.5));
    expect(
      result.gradient.last,
      Color.lerp(Colors.lightBlue, Colors.lightGreen, 0.5),
    );
  });

  test('OnboardingAccentTween.lerp delegates to OnboardingAccent.lerp', () {
    final tween = OnboardingAccentTween(begin: blue, end: green);
    final result = tween.lerp(0.25);
    expect(result.primary, Color.lerp(Colors.blue, Colors.green, 0.25));
  });
}
