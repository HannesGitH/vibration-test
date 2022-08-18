part of 'vibration.dart';

@JsonSerializable()
class VibrationPattern {
  const VibrationPattern(this.elements);

  final List<VibrationElement> elements;

  List<int> get amplitudes => elements.map((e) => e.amplitude).toList();
  List<Duration> get durations => elements.map((e) => e.duration).toList();
  List<int> get durationMSs => elements.map((e) => e.durationMS).toList();

  factory VibrationPattern.fromJson(Map<String, dynamic> json) =>
      _$VibrationPatternFromJson(json);

  Map<String, dynamic> toJson() => _$VibrationPatternToJson(this);
}

@JsonSerializable()
class VibrationElement {
  const VibrationElement({
    this.duration = const Duration(milliseconds: 100),
    this.amplitude = 0,
  }) : assert(amplitude >= 0 && amplitude <= 255,
            'Amplitude must be between 0 and 255');

  final Duration duration;
  int get durationMS => duration.inMilliseconds;
  final int amplitude;

  factory VibrationElement.fromJson(Map<String, dynamic> json) =>
      _$VibrationElementFromJson(json);
  Map<String, dynamic> toJson() => _$VibrationElementToJson(this);
}
