import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibrationtest/extensions/list.dart';

import '../../generated/l10n.dart';
import '../../models/vibration/vibration.dart';
import '../vibration/storePatternButton.dart';

part 'myLineChart.dart';
part 'patternController.dart';
part 'patternPreview.dart';

Point? _prevTouch;
bool _isCurrentlyDown = false;
