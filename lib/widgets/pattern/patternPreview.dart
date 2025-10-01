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
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: ColoredBox(
                    color: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withValues(alpha: 0.6),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          child ?? const SizedBox.shrink(),
                          Text(
                            pattern.name,
                            style: Theme.of(context).textTheme.labelSmall,
                            overflow: TextOverflow.fade,
                          ),
                        ],
                      ),
                    ),
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
