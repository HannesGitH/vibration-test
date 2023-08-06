// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a de locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'de';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "appTitle": MessageLookupByLibrary.simpleMessage("Custom Vibrator"),
        "buzzMode": MessageLookupByLibrary.simpleMessage("Buzz-Modus"),
        "buzzmodeInstruction": MessageLookupByLibrary.simpleMessage(
            "Drücke und halte, um zu vibrieren"),
        "buzzmodeStopInstruction":
            MessageLookupByLibrary.simpleMessage("Loslassen, um zu stoppen"),
        "counter": MessageLookupByLibrary.simpleMessage("Zähler"),
        "defaultPattern":
            MessageLookupByLibrary.simpleMessage("Standardmuster"),
        "noCustomVibrationSupport": MessageLookupByLibrary.simpleMessage(
            "Dein Gerät unterstützt keine benutzerdefinierten Vibrationen"),
        "noVibratorFound":
            MessageLookupByLibrary.simpleMessage("Kein Vibrator gefunden"),
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "pattern": MessageLookupByLibrary.simpleMessage("Muster"),
        "patternSavedFailure": MessageLookupByLibrary.simpleMessage(
            "Muster konnte nicht gespeichert werden"),
        "patternSavedSuccess":
            MessageLookupByLibrary.simpleMessage("Muster gespeichert"),
        "presetTitle": MessageLookupByLibrary.simpleMessage("Muster"),
        "repeat": MessageLookupByLibrary.simpleMessage("Wiederholen"),
        "saveCurrentPatternNameField":
            MessageLookupByLibrary.simpleMessage("Name"),
        "saveCurrentPatternTitle":
            MessageLookupByLibrary.simpleMessage("Muster speichern"),
        "settings": MessageLookupByLibrary.simpleMessage("Einstellungen"),
        "speed": MessageLookupByLibrary.simpleMessage("Geschwindigkeit"),
        "stillWorkInProgress":
            MessageLookupByLibrary.simpleMessage("noch in Arbeit"),
        "vibrationStoreTitle":
            MessageLookupByLibrary.simpleMessage("Vibrations-Shop")
      };
}
