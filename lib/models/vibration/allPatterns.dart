part of 'vibration.dart';

class AllPatternNotifier extends StateNotifier<List<VibrationPattern>> {
  AllPatternNotifier()
      : super([
          defaultPattern,
          defaultPattern.copyWith(name: 'anderle'),
          defaultPattern.copyWith(name: 'anderl3e'),
        ]);
}
