part of 'vibration.dart';

class AllPatternNotifier extends StateNotifier<List<VibrationPattern>> {
  AllPatternNotifier()
      : super([
          defaultPattern,
          defaultPattern.copyWith(name: 'anderle'),
          defaultPattern.copyWith(name: 'anderl3e'),
        ]) {
    loadAll();
  }

  Future loadAll() async {
    state = [
      ...await local.getAllPatterns(),
      ...await local.getAssetsPatterns(),
    ];
  }

  void addPattern(VibrationPattern pattern) {
    state = [...state, pattern];
  }
}
