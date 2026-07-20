import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/features/focus/domain/entities/focus_visual_stage.dart';

void main() {
  group('FocusVisualStage.forProgress', () {
    test('0% is growing', () {
      expect(FocusVisualStage.forProgress(0), FocusVisualStage.growing);
    });

    test('just below 33% is growing', () {
      expect(
        FocusVisualStage.forProgress(0.3299),
        FocusVisualStage.growing,
      );
    });

    test('33% is ripening', () {
      expect(
        FocusVisualStage.forProgress(1 / 3),
        FocusVisualStage.ripening,
      );
    });

    test('between 33% and 66% is ripening', () {
      expect(FocusVisualStage.forProgress(0.5), FocusVisualStage.ripening);
    });

    test('just below 66% is ripening', () {
      expect(
        FocusVisualStage.forProgress(0.6599),
        FocusVisualStage.ripening,
      );
    });

    test('66% is settling', () {
      expect(
        FocusVisualStage.forProgress(2 / 3),
        FocusVisualStage.settling,
      );
    });

    test('100% is settling', () {
      expect(FocusVisualStage.forProgress(1), FocusVisualStage.settling);
    });

    test('progress above 1.0 clamps to settling', () {
      expect(FocusVisualStage.forProgress(1.5), FocusVisualStage.settling);
    });

    test('progress below 0.0 clamps to growing', () {
      expect(FocusVisualStage.forProgress(-0.5), FocusVisualStage.growing);
    });
  });
}
