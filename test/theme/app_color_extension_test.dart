import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/theme/app_color_extension.dart';

void main() {
  const start = AppColorsExtension(
    heroGradient: [Colors.black, Colors.black],
    fabColor: Colors.black,
    chipSelectedColor: Colors.black,
    chartPalette: [Colors.black],
  );

  const end = AppColorsExtension(
    heroGradient: [Colors.white, Colors.white],
    fabColor: Colors.white,
    chipSelectedColor: Colors.white,
    chartPalette: [Colors.white],
  );

  test('lerp at t=0 returns the start colors', () {
    final result = start.lerp(end, 0);
    expect(result.fabColor, Colors.black);
  });

  test('lerp at t=1 returns the end colors', () {
    final result = start.lerp(end, 1);
    expect(result.fabColor, Colors.white);
  });

  test('lerp at t=0.5 interpolates between start and end', () {
    final result = start.lerp(end, 0.5);
    final expected = Color.lerp(Colors.black, Colors.white, 0.5);
    expect(result.fabColor, expected);
  });

  test('lerp interpolates every color in heroGradient/chartPalette lists', () {
    final result = start.lerp(end, 0.5);
    expect(result.heroGradient, hasLength(2));
    expect(result.chartPalette, hasLength(1));
    expect(
      result.heroGradient.first,
      Color.lerp(Colors.black, Colors.white, 0.5),
    );
  });

  test('lerp with null other returns this unchanged', () {
    final result = start.lerp(null, 0.5);
    expect(result, same(start));
  });
}
