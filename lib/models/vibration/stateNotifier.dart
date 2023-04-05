// ignore_for_file: dead_code

part of 'vibration.dart';

const int resolutionInMS = 10;
const bool animate = true;

final defaultPattern = VibrationPattern(
  List.generate(
      50,
      (index) => VibrationElement(
            amplitude: (index * 10) % MAX_VIBRATION_AMPLITUDE,
          )),
  name: S.current.defaultPattern,
);

class VibrationPatternNotifier extends StateNotifier<VibrationPattern> {
  VibrationPatternNotifier() : super(defaultPattern);

  void setPattern(VibrationPattern pattern) {
    state = pattern;
    // No need to call "notifyListeners" or anything similar. Calling "state ="
    // will automatically rebuild the UI when necessary.
  }

  void changeAmplitudeAtMS({required int newAmplitude, required int atMS}) {
    newAmplitude = newAmplitude.clamp(0, MAX_VIBRATION_AMPLITUDE);
    // final oldElements = state.elements;
    final closest = state.elements.indexOfClosest((elem) => atMS - elem.xy!.x);

    final replaceNotInsert =
        //
        true;
    //TODO: instertion is kinda buggy
    closest.e2.abs() <= resolutionInMS;

    final insertBeforeOffset = closest.e2 <= 0 ? 1 : 0;

    final idx = max(closest.e1 - insertBeforeOffset, 0);
    final nextElement = state.elements.safeAt(idx + 1);
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

    final prevElement = state.elements.safeAt(idx);

    final newPrevElement =
        // (replaceNotInsert)
        //     ? prevElement
        //     :
        prevElement?.copyWith(
      duration: Duration(milliseconds: atMS - prevElement.xy!.x),
    );

    //TODO: wahrscheinlich ist die rhList zu früh beginnend wenn man ganz am anfang ist und nichts inserten will
    final lhList = state.elements.safeSublist(0, idx);
    final rhList = state.elements.safeSublist(idx + 1);
    final elements = [
      ...lhList,
      if (!replaceNotInsert && newPrevElement != null) newPrevElement,
      newElement,
      ...rhList,
    ];

    state = state.copyWith(elements: elements, doNotAnimate: true);

    // debugPrint(
    //     '${replaceNotInsert ? 'replaced' : 'inserted'} at $atMS ->[${closest.e1}]: \n\t ${oldElements.map((e) => e.xy).join(', ')}\n\t ${elements.map((e) => e.xy).join(', ')}\n\t ${state.elements.map((e) => e.xy).join(', ')}');
  }

  void setOnRepeat(bool onRepeat) {
    state = state.copyWith(onRepeat: onRepeat, doNotAnimate: false);
  }

  void setSpeedModifier(num speedModifier) {
    state = state.copyWith(speedModifier: speedModifier, doNotAnimate: false);
    if (state.isCurrentlyVibrating) {
      stopVib();
      _wasPausedToContinue = true;

      // startVib();
    }
  }

  void resetPattern() {
    state = defaultPattern;
  }

  void startVib({BuildContext? context}) async {
    // TODO: test whether we need to insert 0s in the pattern for durantion of vibration off
    try {
      if (!(await Vibration.hasVibrator() ?? false)) {
        showToast(S.current.noVibratorFound, context: context);
        return;
      }
      if (!(await Vibration.hasCustomVibrationsSupport() ?? false)) {
        showToast(S.current.noCustomVibrationSupport, context: context);
        Vibration.vibrate();
        return;
      }
    } catch (e) {
      showToast(S.current.noVibratorFound, context: context);
      return;
    }

    var didFirst = false;
    state = state.copyWith(isCurrentlyVibrating: true, doNotAnimate: false);
    while ((state.onRepeat || !didFirst) && state.isCurrentlyVibrating) {
      didFirst = true;
      await Vibration.vibrate(
          pattern: state.durationMSsScaled, intensities: state.amplitudes);

      if (animate)
        await animateVibration();
      else
        await Future.delayed(Duration(
            milliseconds: state.totalDurationMS ~/ state.speedModifier));
    }
    state = state.copyWith(isCurrentlyVibrating: false, doNotAnimate: false);
  }

  animateVibration() async {
    for (int i = 0;
        i < state.elements.length && state.isCurrentlyVibrating;
        i++) {
      final e = state.elements.first;
      // if (e.amplitude != 0)
      // await Vibration.vibrate(duration: e.durationMS, amplitude: e.amplitude);
      await Future.delayed(
          Duration(milliseconds: e.durationMS ~/ state.speedModifier));

      state = state.copyWith(
          elements: [...state.elements.safeSublist(1), e],
          doNotAnimate: (i != 0 && i != state.elements.length - 1));
    }
  }

  void stopVib() {
    state = state.copyWith(isCurrentlyVibrating: false, doNotAnimate: false);
    Vibration.cancel();
  }

  bool _wasPausedToContinue = false;
  void maybeContinueVib() {
    if (_wasPausedToContinue) startVib();
    _wasPausedToContinue = false;
  }
}
