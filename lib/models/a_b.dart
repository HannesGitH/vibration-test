import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'a_b.g.dart';

@riverpod
class Variant extends _$Variant {
  @override
  VariantState? build() {
    load();
    return null;
  }

  final _key = 'variant';
  final _prefs = SharedPreferencesAsync();
  void load() async {
    final variantString = await _prefs.getString(_key);
    if (variantString == null) {
      state = _createVariant();
      return;
    }
    state = VariantState.fromString(variantString);
  }

  VariantState _createVariant() {
    final random = Random();
    final variant = random.nextBool() ? AdVariant() : ReviewVariant();
    _prefs.setString(_key, variant.toString());
    return variant;
  }
}

sealed class VariantState {
  const VariantState();
  factory VariantState.fromString(String value) {
    return switch (value) {
      'ad' => AdVariant(),
      'review' => ReviewVariant(),
      _ => throw UnimplementedError(),
    };
  }
  @override
  String toString() {
    return switch (this) {
      AdVariant() => 'ad',
      ReviewVariant() => 'review',
    };
  }
}

final class AdVariant extends VariantState {}

final class ReviewVariant extends VariantState {}
