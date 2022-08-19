part of 'vibration.dart';

final activeVibrationPatternProvider =
    StateNotifierProvider<VibrationPatternNotifier, VibrationPattern>((ref) {
  return VibrationPatternNotifier();
});

final allPatternsProvider =
    StateNotifierProvider<AllPatternNotifier, List<VibrationPattern>>((ref) {
  return AllPatternNotifier();
});
