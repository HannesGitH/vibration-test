part of 'vibration.dart';

const int resolutionInMS = 10;

class VibrationPatternNotifier extends StateNotifier<VibrationPattern> {
  VibrationPatternNotifier() : super(defaultPattern);

  static final defaultPattern = VibrationPattern(
    List.generate(
        100,
        (index) => VibrationElement(
              amplitude: (index * 10) % MAX_VIBRATION_AMPLITUDE,
            )),
    name: S.current.defaultPattern,
  );

  void setPattern(VibrationPattern pattern) {
    state = pattern;
    // No need to call "notifyListeners" or anything similar. Calling "state ="
    // will automatically rebuild the UI when necessary.
  }

  void changeAmplitudeAtMS({required int newAmplitude, required int atMS}) {
    // final oldElements = state.elements;
    final closest = state.elements.indexOfClosest((elem) => atMS - elem.xy!.x);

    final replaceNotInsert = true;
    //TODO: instertion is kinda buggy
    //closest.e2.abs() <= resolutionInMS;

    final insertBeforeOffset = closest.e2 <= 0 ? 1 : 0;
    final nextElement =
        state.elements.safeAt(closest.e1 - insertBeforeOffset + 1);
    final newElement = state.elements.safeAt(closest.e1)!.copyWith(
          amplitude: newAmplitude,
          duration: replaceNotInsert
              ? null
              : Duration(
                  milliseconds: nextElement == null
                      ? resolutionInMS * 2
                      : nextElement.xy!.x - atMS),
        );

    // if (replaceNotInsert) {
    //   final elements = [
    //     ...state.elements.safeSublist(0, closest.e1),
    //     newElement,
    //     ...state.elements.safeSublist(closest.e1 + 1),
    //   ];

    //   state = state.copyWith(elements: elements);
    //   return;
    // }
    // if (replaceNotInsert) insertBeforeOffset = 0;

    final prevElement = state.elements.safeAt(closest.e1 - insertBeforeOffset);

    final newPrevElement =
        // (replaceNotInsert)
        //     ? prevElement
        //     :
        prevElement?.copyWith(
      duration: Duration(milliseconds: atMS - prevElement.xy!.x),
    );

    //TODO: wahrscheinlich ist die rhList zu früh beginnend wenn man ganz am anfang ist und nichts inserten will
    final lhList =
        state.elements.safeSublist(0, closest.e1 - insertBeforeOffset);
    final rhList =
        state.elements.safeSublist(closest.e1 + 1 - insertBeforeOffset);
    final elements = [
      ...lhList,
      if (!replaceNotInsert && newPrevElement != null) newPrevElement,
      newElement,
      ...rhList,
    ];

    state = state.copyWith(elements: elements);

    // debugPrint(
    //     '${replaceNotInsert ? 'replaced' : 'inserted'} at $atMS ->[${closest.e1}]: \n\t ${oldElements.map((e) => e.xy).join(', ')}\n\t ${elements.map((e) => e.xy).join(', ')}\n\t ${state.elements.map((e) => e.xy).join(', ')}');
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
    await Future.delayed(
        Duration(milliseconds: state.totalDurationMS ~/ state.speedModifier));
    state = state.copyWith(isCurrentlyVibrating: false);
  }

  void stopVib() {
    state = state.copyWith(isCurrentlyVibrating: false);
    Vibration.cancel();
  }
}
