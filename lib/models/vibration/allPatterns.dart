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
    const max = MAX_VIBRATION_AMPLITUDE;
    // bail early we already have the newest pattern
    const riseAndShineName = 'd:rise_and_shine';
    if (state.any((p) => p.name == riseAndShineName)) return;

    final zigZagWave = VibrationPattern(
      List.generate(
          50, (i) => VibrationElement(amplitude: ((i / 50) * max).toInt())),
      name: 'd:zigzag',
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
    final lowMiddleHighWave = VibrationPattern(
      List.generate(
          60,
          (i) => VibrationElement(
                  amplitude: switch (i) {
                < 20 => max ~/ 3,
                < 40 => max ~/ 3 * 2,
                _ => max,
              })),
      name: 'd:low_middle_high',
    );
    final riseAndShineWave = VibrationPattern(
      List.generate(
          60,
          (i) => VibrationElement(
                  amplitude: switch (i) {
                < 30 => (Curves.easeInOut.transform(i / 30) * max).toInt(),
                _ => max,
              })),
      name: riseAndShineName,
    );
    final presets = [
      zigZagWave,
      sineWave,
      squareWave,
      chaosWave,
      lowMiddleHighWave,
      riseAndShineWave,
    ];
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
