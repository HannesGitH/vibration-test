import 'dart:math';

import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vibration/vibration.dart';
import 'package:vibrationtest/fragments/toaster.dart';
import 'package:vibrationtest/widgets/pattern/pattern.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../extensions/list.dart';

import '../../generated/l10n.dart';
import '../../storage/local.dart' as local;

part 'stateNotifier.dart';
part 'stateNotifierProvider.dart';
part 'pattern.dart';

part 'allPatterns.dart';

part 'vibration.g.dart';
