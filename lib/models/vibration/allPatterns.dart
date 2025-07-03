part of 'vibration.dart';

class AllPatternNotifier extends StateNotifier<List<VibrationPattern>> {
  AllPatternNotifier() : super([]) {
    reloadFromFS();
  }

  Future<void> reloadFromFS() async {
    state = await local.getAllPatterns();
    await loadDefaultsIfNeeded();
  }

  Future<void> loadDefaultsIfNeeded() async {
    const zigZagName = 'd:zigzag';
    if (state.any((p) => p.name == zigZagName)) return;
    const max = MAX_VIBRATION_AMPLITUDE;
    final zigZagWave = VibrationPattern(
      List.generate(
          50, (i) => VibrationElement(amplitude: ((i / 50) * max).toInt())),
      name: zigZagName,
    );
    final sineWave = VibrationPattern(
      List.generate(
          50,
          (i) => VibrationElement(
              amplitude: ((sin(i / 50 * pi * 4) * max / 2 + max / 2).toInt()))),
      name: 'd:sine',
    );
    final squareWave = VibrationPattern(
      List.generate(
          50,
          (i) => VibrationElement(
                amplitude: i < 25 ? max : 0,
              )),
      name: 'd:square',
    );
    final random = Random();
    final chaosWave = VibrationPattern(
      List.generate(
          50, (i) => VibrationElement(amplitude: random.nextInt(max))),
      name: 'd:chaos',
    );
    final presets = [zigZagWave, sineWave, squareWave, chaosWave];
    for (var preset in presets) {
      await local.savePattern(preset);
      if (state.any((p) => p.name == preset.name)) continue;
      addPattern(preset);
    }
  }

  void addPattern(VibrationPattern pattern) {
    state = [...state, pattern];
  }
}
