part of 'vibration.dart';

class VibrationPatternNotifier extends StateNotifier<VibrationPattern> {
  VibrationPatternNotifier() : super(defaultPattern);

  static const defaultPattern = VibrationPattern([
    VibrationElement(amplitude: 100),
  ]);

  void setPattern(VibrationPattern pattern) {
    state = pattern;
    // No need to call "notifyListeners" or anything similar. Calling "state ="
    // will automatically rebuild the UI when necessary.
  }

  void resetPattern() {
    state = defaultPattern;
  }

  void vibrate() {
    // TODO: test whether we need to insert 0s in the pattern for durantion of vibration off
    Vibration.vibrate(
        pattern: state.durationMSs, intensities: state.amplitudes);
  }
}
