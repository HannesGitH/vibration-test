// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vibration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VibrationPattern _$VibrationPatternFromJson(Map<String, dynamic> json) =>
    VibrationPattern(
      (json['elements'] as List<dynamic>)
          .map((e) => VibrationElement.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VibrationPatternToJson(VibrationPattern instance) =>
    <String, dynamic>{
      'elements': instance.elements,
    };

VibrationElement _$VibrationElementFromJson(Map<String, dynamic> json) =>
    VibrationElement(
      duration: json['duration'] == null
          ? const Duration(milliseconds: 100)
          : Duration(microseconds: json['duration'] as int),
      amplitude: json['amplitude'] as int? ?? 0,
    );

Map<String, dynamic> _$VibrationElementToJson(VibrationElement instance) =>
    <String, dynamic>{
      'duration': instance.duration.inMicroseconds,
      'amplitude': instance.amplitude,
    };
