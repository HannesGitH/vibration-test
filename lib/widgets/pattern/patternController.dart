part of 'pattern.dart';

class PatternController extends ConsumerWidget {
  const PatternController({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    VibrationPattern pattern = ref.watch(activeVibrationPatternProvider);

    onTouch(num relativeX, num relativeY) {
      final notifier = ref.read(activeVibrationPatternProvider.notifier);
      num x = max(
        ((relativeX.clamp(0, 1) + (1 / pattern.elements.length)) *
            pattern.totalDurationMS),
        pattern.elements.safeAt(2)?.durationMS ?? 0 - (resolutionInMS ~/ 2),
      );
      num y = (1 - relativeY.clamp(0, 1.1)) * MAX_VIBRATION_AMPLITUDE;
      if (_prevTouch != null) {
        num xp = max(
          ((_prevTouch!.x.clamp(0, 1) + (1 / pattern.elements.length)) *
              pattern.totalDurationMS),
          pattern.elements.safeAt(2)?.durationMS ?? 0 - (resolutionInMS ~/ 2),
        );
        num yp = (1 - _prevTouch!.y.clamp(0, 1.1)) * MAX_VIBRATION_AMPLITUDE;

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
                        child: MyLineChart(
                          onTouchCallBack: onTouch,
                          data: data,
                          min: Point(firstDuration, 0),
                          max: Point(
                            pattern.totalDurationMS,
                            MAX_VIBRATION_AMPLITUDE,
                          ),
                          animationDuration: pattern.doNotAnimate ? 5 : 100,
                          showDot: pattern.isCurrentlyVibrating,
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
