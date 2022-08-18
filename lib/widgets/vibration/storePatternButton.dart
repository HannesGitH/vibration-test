import 'package:flutter/material.dart';
import 'package:vibrationtest/storage/local.dart';

import '../../models/vibration/vibration.dart';

class StorePatternButton extends StatefulWidget {
  const StorePatternButton({Key? key, required this.pattern}) : super(key: key);

  final VibrationPattern pattern;

  @override
  State<StorePatternButton> createState() => _StorePatternButtonState();
}

class _StorePatternButtonState extends State<StorePatternButton> {
  SavingState _state = SavingState.idle;

  save() async {
    setState(() {
      _state = SavingState.saving;
    });
    try {
      await savePattern(widget.pattern);
      setState(() {
        _state = SavingState.saved;
      });
    } catch (e) {
      setState(() {
        _state = SavingState.error;
      });
    }
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _state = SavingState.idle;
    });
  }

  Widget get _icon {
    switch (_state) {
      case SavingState.idle:
        return const Icon(Icons.save);
      case SavingState.saving:
        return const CircularProgressIndicator();
      case SavingState.saved:
        return const Icon(Icons.check);
      case SavingState.error:
        return const Icon(Icons.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: save,
      icon: _icon,
    );
  }
}

enum SavingState {
  idle,
  saving,
  saved,
  error,
}
