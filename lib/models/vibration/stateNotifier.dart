part of 'vibration.dart';

class VibrationPatternNotifier extends StateNotifier<VibrationPattern> {
  VibrationPatternNotifier() : super(defaultPattern);

  static final defaultPattern = VibrationPattern(
    const [
      VibrationElement(amplitude: 100),
    ],
    name: S.current.defaultPattern,
  );

  void setPattern(VibrationPattern pattern) {
    state = pattern;
    // No need to call "notifyListeners" or anything similar. Calling "state ="
    // will automatically rebuild the UI when necessary.
  }

  void setOnRepeat(bool onRepeat) {
    state = state.copyWith(onRepeat: onRepeat);
  }

  void setSpeedModifier(num speedModifier) {
    state = state.copyWith(speedModifier: speedModifier);
  }

  void resetPattern() {
    state = defaultPattern;
  }

  void startVib({BuildContext? context}) async {
    // TODO: test whether we need to insert 0s in the pattern for durantion of vibration off
    if (!(await Vibration.hasVibrator() ?? false)) {
      showToast(S.current.noVibratorFound, context: context);
      return;
    }
    if (!(await Vibration.hasCustomVibrationsSupport() ?? false)) {
      showToast(S.current.noCustomVibrationSupport, context: context);
      Vibration.vibrate();
      return;
    }
    await Vibration.vibrate(
        pattern: state.durationMSsScaled, intensities: state.amplitudes);
    state = state.copyWith(isCurrentlyVibrating: true);
  }

  void stopVib() {
    state = state.copyWith(isCurrentlyVibrating: false);
    Vibration.cancel();
  }
}
