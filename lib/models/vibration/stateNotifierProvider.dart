part of 'vibration.dart';

final vibrationPatternProvider =
    StateNotifierProvider<VibrationPatternNotifier, VibrationPattern>((ref) {
  return VibrationPatternNotifier();
});
