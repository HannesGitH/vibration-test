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
          : Duration(microseconds: (json['duration'] as num).toInt()),
      amplitude: (json['amplitude'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$VibrationElementToJson(VibrationElement instance) =>
    <String, dynamic>{
      'duration': instance.duration.inMicroseconds,
      'amplitude': instance.amplitude,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$vibrationPatternNotifierHash() =>
    r'4bd2a8108f0e1b0e4cde55e802d44ea009dd275f';

/// See also [VibrationPatternNotifier].
@ProviderFor(VibrationPatternNotifier)
final vibrationPatternNotifierProvider = AutoDisposeNotifierProvider<
    VibrationPatternNotifier, VibrationPattern>.internal(
  VibrationPatternNotifier.new,
  name: r'vibrationPatternNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$vibrationPatternNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$VibrationPatternNotifier = AutoDisposeNotifier<VibrationPattern>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
