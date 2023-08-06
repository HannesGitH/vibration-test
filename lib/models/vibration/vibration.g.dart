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
      name: json['name'] as String,
      speedModifier: json['speedModifier'] as num? ?? 1.0,
      isCurrentlyVibrating: json['isCurrentlyVibrating'] as bool? ?? false,
      onRepeat: json['onRepeat'] as bool? ?? true,
      wasPausedToContinue: json['wasPausedToContinue'] as bool? ?? false,
    );

Map<String, dynamic> _$VibrationPatternToJson(VibrationPattern instance) =>
    <String, dynamic>{
      'name': instance.name,
      'elements': instance.elements,
      'speedModifier': instance.speedModifier,
      'isCurrentlyVibrating': instance.isCurrentlyVibrating,
      'onRepeat': instance.onRepeat,
      'wasPausedToContinue': instance.wasPausedToContinue,
    };

VibrationElement _$VibrationElementFromJson(Map<String, dynamic> json) =>
    VibrationElement(
      duration: json['duration'] == null
          ? const Duration(milliseconds: resolutionInMS * 5)
          : Duration(microseconds: json['duration'] as int),
      amplitude: json['amplitude'] as int? ?? 0,
    );

Map<String, dynamic> _$VibrationElementToJson(VibrationElement instance) =>
    <String, dynamic>{
      'duration': instance.duration.inMicroseconds,
      'amplitude': instance.amplitude,
    };
