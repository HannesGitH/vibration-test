part of 'vibration.dart';

final activeVibrationPatternProvider = vibrationPatternNotifierProvider;

final allPatternsProvider =
    StateNotifierProvider<AllPatternNotifier, List<VibrationPattern>>((ref) {
  return AllPatternNotifier();
});
