part of 'vibration.dart';

@JsonSerializable()
class VibrationPattern {
  const VibrationPattern(
    this.elements, {
    required this.name,
    this.speedModifier = 1.0,
    this.isCurrentlyVibrating = false,
    this.onRepeat = false,
  });

  final String name;
  final List<VibrationElement> elements;
  final num speedModifier;
  final bool isCurrentlyVibrating;
  final bool onRepeat;
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

  factory VibrationPattern.fromJson(Map<String, dynamic> json) =>
      _$VibrationPatternFromJson(json);

  Map<String, dynamic> toJson() => _$VibrationPatternToJson(this);

  VibrationPattern copyWith({
    List<VibrationElement>? elements,
    String? name,
    num? speedModifier,
    bool? isCurrentlyVibrating,
    bool? onRepeat,
  }) {
    return VibrationPattern(
      elements ?? this.elements,
      name: name ?? this.name,
      speedModifier: speedModifier ?? this.speedModifier,
      isCurrentlyVibrating: isCurrentlyVibrating ?? this.isCurrentlyVibrating,
      onRepeat: onRepeat ?? this.onRepeat,
    );
  }
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
