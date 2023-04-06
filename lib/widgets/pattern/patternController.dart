part of 'pattern.dart';

class PatternController extends ConsumerWidget {
  const PatternController({super.key});

  static Point convertTouchToAmpMs(
      {required num x_, required num y_, required VibrationPattern pattern}) {
    num x = max(
      ((x_.clamp(0, 1) + (1 / pattern.elements.length)) *
          pattern.totalDurationMS),
      pattern.elements.safeAt(2)?.durationMS ?? 0 - (resolutionInMS ~/ 2),
    );
    num y = (1 - y_.clamp(0, 1.1)) * MAX_VIBRATION_AMPLITUDE;
    return Point(x, y);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    VibrationPattern pattern = ref.watch(activeVibrationPatternProvider);

    onTouch(num x_, num y_) {
      final notifier = ref.read(activeVibrationPatternProvider.notifier);

      // notifier.stopVib();

      final Point touch = convertTouchToAmpMs(x_: x_, y_: y_, pattern: pattern);
      num x = touch.x;
      num y = touch.y;

      if (_prevTouch != null) {
        final Point prev = convertTouchToAmpMs(
            x_: _prevTouch!.x, y_: _prevTouch!.y, pattern: pattern);
        num xp = prev.x;
        num yp = prev.y;

        if (xp != x) {
          if (xp < x) {
            final tmpx = x;
            final tmpy = y;
            y = yp;
            yp = tmpy;
            x = xp;
            xp = tmpx;
          }
          final delta = (yp - y) / (xp - x);
          var currentX = x;
          while (currentX < xp) {
            notifier.changeAmplitudeAtMS(
              atMS: currentX.toInt(),
              newAmplitude: ((currentX - x) * delta + y).toInt(),
            );
            currentX += resolutionInMS;
          }
        }
      }
      // debugPrint('$relativeX $relativeY $x $y');

      notifier.changeAmplitudeAtMS(newAmplitude: y.toInt(), atMS: x.toInt());
    }

    final firstDuration =
        pattern.elements.isEmpty ? 0 : pattern.elements.first.durationMS;

    final data = pattern.points;

    // if (pattern.isCurrentlyVibrating &&
    //     _isCurrentlyDown &&
    //     _prevTouch != null) {
    //   onTouch(_prevTouch!.x, _prevTouch!.y);
    // }
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(S.of(context).pattern),
                  Text(
                    pattern.name,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ),
            Expanded(
              child: SizedBox.expand(
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Card(
                      shadowColor: Colors.transparent,
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 30.0,
                          top: 30.0,
                          right: 20.0,
                          left: 20.0,
                        ),
                        child: Stack(
                          children: [
                            // MyLineChart(
                            //   onTouchCallBack: onTouch,
                            //   data: data,
                            //   min: Point(firstDuration, 0),
                            //   max: Point(
                            //     pattern.totalDurationMS,
                            //     MAX_VIBRATION_AMPLITUDE,
                            //   ),
                            //   animationDuration: pattern.doNotAnimate ? 5 : 100,
                            //   showDot: pattern.isCurrentlyVibrating,
                            // ),
                            Listener(
                              onPointerDown: (event) => ref
                                  .read(activeVibrationPatternProvider.notifier)
                                  .pauseVib(),
                              onPointerUp: (event) => ref
                                  .read(activeVibrationPatternProvider.notifier)
                                  .maybeContinueVib(),
                              // GestureDetector(
                              //   behavior: HitTestBehavior.opaque,
                              // onTapDown: (_) => ref
                              //     .read(activeVibrationPatternProvider.notifier)
                              //     .pauseVib(),
                              // onTapUp: (_) => ref
                              //     .read(activeVibrationPatternProvider.notifier)
                              //     .maybeContinueVib(),
                              // onTapCancel: () => ref
                              //     .read(activeVibrationPatternProvider.notifier)
                              //     .maybeContinueVib(),
                              // onLongPressUp: () => ref
                              //     .read(activeVibrationPatternProvider.notifier)
                              //     .maybeContinueVib(),
                              // onLongPressCancel: () => ref
                              //     .read(activeVibrationPatternProvider.notifier)
                              //     .maybeContinueVib(),
                              // onLongPressEnd: (details) => ref
                              //     .read(activeVibrationPatternProvider.notifier)
                              //     .maybeContinueVib(),
                              // onPanEnd: (details) => ref
                              //     .read(activeVibrationPatternProvider.notifier)
                              //     .maybeContinueVib(),
                              // onPanCancel: () => ref
                              //     .read(activeVibrationPatternProvider.notifier)
                              //     .maybeContinueVib(),
                              child: MyLineChart(
                                onTouchCallBack: onTouch,
                                data: data,
                                min: Point(firstDuration, 0),
                                max: Point(
                                  pattern.totalDurationMS,
                                  MAX_VIBRATION_AMPLITUDE,
                                ),
                                animationDuration:
                                    pattern.doNotAnimate ? 5 : 100,
                                showDot: pattern.isCurrentlyVibrating,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SaveCurrentPatternButton(),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
