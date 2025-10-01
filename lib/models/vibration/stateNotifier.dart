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

@riverpod
class VibrationPatternNotifier extends _$VibrationPatternNotifier {
  @override
  VibrationPattern build() {
    final first = ref.watch(allPatternsProvider).firstOrNull;
    return first ?? defaultPattern;
  }

  bool get allowCPUWL => ref.read(wakeLockOptionsProvider).cpu;
  bool get allowScreenWL => ref.read(wakeLockOptionsProvider).screen;

  void setPattern(VibrationPattern pattern) {
    state = pattern;
    // No need to call "notifyListeners" or anything similar. Calling "state ="
    // will automatically rebuild the UI when necessary.
  }

  void pauseVib() {
    if (state.isCurrentlyVibrating) {
      stopVib();
      state = state.copyWith(wasPausedToContinue: true, doNotAnimate: false);
    }
    if (ref.read(variantProvider) is AdVariant) {
      Review.request();
    }
  }

  void changeAmplitudeAtMS({required int newAmplitude, required int atMS}) {
    newAmplitude = newAmplitude.clamp(0, MAX_VIBRATION_AMPLITUDE);
    // pauseVib();
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
    pauseVib();
  }

  void resetPattern() {
    state = defaultPattern;
  }

  void startVib({BuildContext? context}) async {
    // TODO: test whether we need to insert 0s in the pattern for durantion of vibration off
    if (allowCPUWL)
      try {
        WakelockPlus.toggleCPU(enable: true);
      } catch (e) {}
    if (allowScreenWL)
      try {
        WakelockPlus.toggle(enable: true);
      } catch (e) {}
    try {
      if (!(await Vibration.hasVibrator())) {
        showToast(S.current.noVibratorFound, context: context);
        return;
      }
      if (!(await Vibration.hasCustomVibrationsSupport())) {
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
    final scaledPattern = state.durationMSsScaled;
    final scaledPatternX5 = [...scaledPattern, ...scaledPattern, ...scaledPattern, ...scaledPattern, ...scaledPattern];
    final amplitudesX5 = [...state.amplitudes, ...state.amplitudes, ...state.amplitudes, ...state.amplitudes, ...state.amplitudes];
    while ((state.onRepeat || !didFirst) && state.isCurrentlyVibrating) {
      didFirst = true;
      Vibration.vibrate(
          pattern: scaledPatternX5, intensities: amplitudesX5);

      if (animate) {
        // if (prevTouch != null && isCurrentlyDown) {
        //   final Point converted = PatternController.convertTouchToAmpMs(
        //       x_: prevTouch!.x, y_: prevTouch!.y, pattern: this.state);
        //   changeAmplitudeAtMS(
        //       newAmplitude: converted.y.toInt(), atMS: converted.x.toInt());
        // }
        await animateVibration();
      } else
        await Future.delayed(Duration(
            milliseconds: state.totalDurationMS ~/ state.speedModifier));
    }
    state = state.copyWith(isCurrentlyVibrating: false, doNotAnimate: false);
  }

  animateVibration() async {
    for (int i = 0;
        i < state.elements.length && state.isCurrentlyVibrating;
        i++) {
      final start = DateTime.now();
      final e = state.elements.first;

      state = state.copyWith(
          elements: [...state.elements.safeSublist(1), e],
          doNotAnimate: (i != 0 && i != state.elements.length - 1));

      final nominalWait = 1000 * (e.durationMS ~/ state.speedModifier);
      final deltaElapsed = DateTime.now().difference(start).inMicroseconds;
      await Future.delayed(
          Duration(microseconds: nominalWait - deltaElapsed));
    }
  }

  Future<void> stopVib() async {
    try {
      await Vibration.vibrate(duration: 0);
    } catch (e) {}
    await Vibration.cancel();
    state = state.copyWith(isCurrentlyVibrating: false, doNotAnimate: false);
    try {
      WakelockPlus.toggleCPU(enable: false);
    } catch (e) {}
    WakelockPlus.toggle(enable: false);
  }

  void maybeContinueVib() {
    if (state.wasPausedToContinue) {
      startVib();
      state = state.copyWith(wasPausedToContinue: false, doNotAnimate: false);
    }
  }
}
