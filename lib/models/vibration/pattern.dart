part of 'vibration.dart';

const MAX_VIBRATION_AMPLITUDE = 255;

List<VibrationElement> _addPointsToElements(List<VibrationElement> elements) {
  var accX = 0;
  return elements.map((vibElem) {
    accX += vibElem.durationMS;
    return vibElem.copyWith(
      xy: Point(
        accX,
        vibElem.amplitude,
      ),
    );
  }).toList();
}

@immutable
@JsonSerializable()
class VibrationPattern {
  VibrationPattern(
    List<VibrationElement> elements, {
    required this.name,
    this.speedModifier = 1.0,
    this.isCurrentlyVibrating = false,
    this.onRepeat = false,
    this.doNotAnimate = false,
    // ignore: unnecessary_this
  }) : this.elements = _addPointsToElements(elements);

  final String name;
  final List<VibrationElement> elements;
  final num speedModifier;
  final bool isCurrentlyVibrating;
  final bool onRepeat;
  @JsonKey(ignore: true)
  final bool doNotAnimate;
  String get id => name;

  int get id2 => (name +
          speedModifier.toString() +
          onRepeat.toString() +
          elements.map((e) => e.amplitude).join())
      .codeUnits
      .fold<int>(0, (p, e) => p * 37 + e);

  List<int> get amplitudes => elements.map((e) => e.amplitude).toList();
  List<Duration> get durations => elements.map((e) => e.duration).toList();
  List<int> get durationMSs => elements.map((e) => e.durationMS).toList();
  List<int> get durationMSsScaled =>
      durationMSs.map((ms) => ms ~/ speedModifier).toList();

  List<Point> get points => elements.map((e) => e.xy!).toList();

  int get totalDurationMS => durationMSs.fold(0, (p, e) => p + e);

  factory VibrationPattern.fromJson(Map<String, dynamic> json) =>
      _$VibrationPatternFromJson(json);

  Map<String, dynamic> toJson() => _$VibrationPatternToJson(this);

  VibrationPattern copyWith({
    List<VibrationElement>? elements,
    String? name,
    num? speedModifier,
    bool? isCurrentlyVibrating,
    bool? onRepeat,
    bool? doNotAnimate,
  }) {
    return VibrationPattern(
      elements ?? this.elements,
      name: name ?? this.name,
      speedModifier: speedModifier ?? this.speedModifier,
      isCurrentlyVibrating: isCurrentlyVibrating ?? this.isCurrentlyVibrating,
      onRepeat: onRepeat ?? this.onRepeat,
      doNotAnimate: doNotAnimate ?? this.doNotAnimate,
    );
  }
}

@immutable
@JsonSerializable()
class VibrationElement {
  const VibrationElement({
    this.duration = const Duration(milliseconds: resolutionInMS * 5),
    this.amplitude = 0,
    this.xy,
  }) : assert(amplitude >= 0 && amplitude <= MAX_VIBRATION_AMPLITUDE,
            'Amplitude must be between 0 and $MAX_VIBRATION_AMPLITUDE');

  final Duration duration;
  int get durationMS => duration.inMilliseconds;
  final int amplitude;
  final Point<int>? xy;

  factory VibrationElement.fromJson(Map<String, dynamic> json) =>
      _$VibrationElementFromJson(json);
  Map<String, dynamic> toJson() => _$VibrationElementToJson(this);

  VibrationElement copyWith({
    Duration? duration,
    int? amplitude,
    Point<int>? xy,
  }) {
    return VibrationElement(
      duration: duration ?? this.duration,
      amplitude: amplitude ?? this.amplitude,
      xy: xy ?? this.xy,
    );
  }
}
