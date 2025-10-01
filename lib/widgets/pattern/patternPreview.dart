part of 'pattern.dart';

class PatternPreview extends StatelessWidget {
  const PatternPreview({
    super.key,
    required this.pattern,
    this.elevation = 5,
    this.child,
  });
  final VibrationPattern pattern;
  final double elevation;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final firstDuration =
        pattern.elements.isEmpty ? 0 : pattern.elements.first.durationMS;

    return AspectRatio(
      aspectRatio: 1.3,
      child: Card(
        shadowColor: Colors.transparent,
        elevation: elevation,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MyLineChart(
                  data: pattern.points,
                  min: Point(firstDuration, 0),
                  max: Point(
                    pattern.totalDurationMS,
                    MAX_VIBRATION_AMPLITUDE,
                  ),
                ),
              ),
              Card(
                elevation: elevation,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      child ?? const SizedBox.shrink(),
                      Expanded(
                        child: Text(
                          pattern.name,
                          style: Theme.of(context).textTheme.labelSmall,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
