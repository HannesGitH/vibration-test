import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibrationtest/fragments/toaster.dart';
import 'package:vibrationtest/storage/local.dart';

import '../../generated/l10n.dart';
import '../../models/vibration/vibration.dart';

class SaveCurrentPatternButton extends ConsumerWidget {
  const SaveCurrentPatternButton({Key? key}) : super(key: key);

  void onSaved(VibrationPattern? pattern, WidgetRef ref) async {
    final success = pattern != null;
    if (success) {
      await ref.read(allPatternsProvider.notifier).reloadFromFS();
      ref.read(activeVibrationPatternProvider.notifier).setPattern(pattern);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    VibrationPattern pattern = ref.watch(activeVibrationPatternProvider);
    return StorePatternButton(
      pattern: pattern,
      onDone: ((pattern) => onSaved(pattern, ref)),
    );
  }
}

class StorePatternButton extends StatefulWidget {
  const StorePatternButton({Key? key, required this.pattern, this.onDone})
      : super(key: key);

  final VibrationPattern pattern;
  final Function(VibrationPattern? newPattern)? onDone;

  @override
  State<StorePatternButton> createState() => _StorePatternButtonState();
}

class _StorePatternButtonState extends State<StorePatternButton> {
  SavingState _state = SavingState.idle;

  save(context) {
    final _controller = TextEditingController(text: widget.pattern.name);
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(S.of(context).saveCurrentPatternTitle),
              content: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: S.of(context).saveCurrentPatternNameField,
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      final pattern =
                          widget.pattern.copyWith(name: _controller.text);
                      _save(pattern).then((success) => showToast(
                          success
                              ? S.of(context).patternSavedSuccess
                              : S.of(context).patternSavedFailure,
                          context: context));
                      ;
                      Navigator.of(context).pop();
                    },
                    child: Text(S.of(context).ok)),
              ],
            ));
  }

  Future<bool> _save(pattern) async {
    setState(() {
      _state = SavingState.saving;
    });
    try {
      await savePattern(pattern);
      setState(() {
        _state = SavingState.saved;
      });
    } catch (e) {
      setState(() {
        _state = SavingState.error;
      });
    }
    final success = _state == SavingState.saved;
    widget.onDone?.call(success ? pattern : null);
    Future.delayed(const Duration(seconds: 2)).then((value) => setState(() {
          _state = SavingState.idle;
        }));
    return success;
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
      onPressed: () => save(context),
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
