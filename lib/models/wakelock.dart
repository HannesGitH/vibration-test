import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'wakelock.g.dart';

@riverpod
class WakeLockOptions extends _$WakeLockOptions {
  @override
  WakeLockData build() {
    SharedPreferences.getInstance().then((prefs) {
      final cpu = prefs.getBool('cpuWL');
      final screen = prefs.getBool('screenWL');
      if (cpu != null) setCpu(cpu);
      if (screen != null) setScreen(screen);
    });
    return WakeLockData();
  }

  toggleScreen() {
    state = state.copyWith(screen: !state.screen);
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('screenWL', state.screen);
    });
  }

  toggleCpu() {
    debugPrint("toggling CPU WL");
    state = state.copyWith(cpu: !state.cpu);
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('cpuWL', state.cpu);
    });
  }

  allowScreen() {
    if (state.screen) return;
    toggleScreen();
  }

  allowCpu() {
    if (state.cpu) return;
    toggleCpu();
  }

  disallowScreen() {
    if (!state.screen) return;
    toggleScreen();
  }

  disallowCpu() {
    if (!state.cpu) return;
    toggleCpu();
  }

  setScreen(bool value) {
    if (value) {
      allowScreen();
    } else {
      disallowScreen();
    }
  }

  setCpu(bool value) {
    if (value) {
      debugPrint('allowing CPU WL');
      allowCpu();
    } else {
      disallowCpu();
    }
  }
}

class WakeLockData {
  bool screen = false;
  bool cpu = false;

  WakeLockData copyWith({bool? screen, bool? cpu}) {
    return WakeLockData()
      ..screen = screen ?? this.screen
      ..cpu = cpu ?? this.cpu;
  }
}
