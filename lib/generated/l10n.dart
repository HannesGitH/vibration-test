// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Custom Vibrator`
  String get appTitle {
    return Intl.message(
      'Custom Vibrator',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Counter`
  String get counter {
    return Intl.message(
      'Counter',
      name: 'counter',
      desc: '',
      args: [],
    );
  }

  /// `Speed`
  String get speed {
    return Intl.message(
      'Speed',
      name: 'speed',
      desc: '',
      args: [],
    );
  }

  /// `Loop`
  String get repeat {
    return Intl.message(
      'Loop',
      name: 'repeat',
      desc: '',
      args: [],
    );
  }

  /// `No vibrator found`
  String get noVibratorFound {
    return Intl.message(
      'No vibrator found',
      name: 'noVibratorFound',
      desc: '',
      args: [],
    );
  }

  /// `This device does not support custom vibrations`
  String get noCustomVibrationSupport {
    return Intl.message(
      'This device does not support custom vibrations',
      name: 'noCustomVibrationSupport',
      desc: '',
      args: [],
    );
  }

  /// `default pattern`
  String get defaultPattern {
    return Intl.message(
      'default pattern',
      name: 'defaultPattern',
      desc: '',
      args: [],
    );
  }

  /// `still work in progress`
  String get stillWorkInProgress {
    return Intl.message(
      'still work in progress',
      name: 'stillWorkInProgress',
      desc: '',
      args: [],
    );
  }

  /// `Vibration Store`
  String get vibrationStoreTitle {
    return Intl.message(
      'Vibration Store',
      name: 'vibrationStoreTitle',
      desc: '',
      args: [],
    );
  }

  /// `Pattern`
  String get pattern {
    return Intl.message(
      'Pattern',
      name: 'pattern',
      desc: '',
      args: [],
    );
  }

  /// `Presets`
  String get presetTitle {
    return Intl.message(
      'Presets',
      name: 'presetTitle',
      desc: '',
      args: [],
    );
  }

  /// `Save Pattern`
  String get saveCurrentPatternTitle {
    return Intl.message(
      'Save Pattern',
      name: 'saveCurrentPatternTitle',
      desc: '',
      args: [],
    );
  }

  /// `name`
  String get saveCurrentPatternNameField {
    return Intl.message(
      'name',
      name: 'saveCurrentPatternNameField',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `pattern Saved`
  String get patternSavedSuccess {
    return Intl.message(
      'pattern Saved',
      name: 'patternSavedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Pattern could not be saved`
  String get patternSavedFailure {
    return Intl.message(
      'Pattern could not be saved',
      name: 'patternSavedFailure',
      desc: '',
      args: [],
    );
  }

  /// `Buzz Mode`
  String get buzzMode {
    return Intl.message(
      'Buzz Mode',
      name: 'buzzMode',
      desc: '',
      args: [],
    );
  }

  /// `tap anywhere to go brrrrrr`
  String get buzzmodeInstruction {
    return Intl.message(
      'tap anywhere to go brrrrrr',
      name: 'buzzmodeInstruction',
      desc: '',
      args: [],
    );
  }

  /// `release to stop`
  String get buzzmodeStopInstruction {
    return Intl.message(
      'release to stop',
      name: 'buzzmodeStopInstruction',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'de'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
