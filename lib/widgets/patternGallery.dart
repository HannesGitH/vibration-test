import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibrationtest/widgets/pattern/pattern.dart';

import '../generated/l10n.dart';
import '../models/vibration/vibration.dart';

class PatternGallery extends ConsumerWidget {
  const PatternGallery({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patterns = ref.watch(allPatternsProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(S.of(context).presetTitle),
                IconButton(
                    onPressed: () => Navigator.pushNamed(context, '/gallery'),
                    icon: const Icon(Icons.chevron_right))
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: patterns.length + 2,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0 || index == patterns.length + 1) {
                  return const SizedBox(width: 10.0);
                }
                return GalleryPatternPreview(pattern: patterns[index - 1]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class GalleryPatternPreview extends ConsumerWidget {
  const GalleryPatternPreview({required this.pattern, super.key});
  final VibrationPattern pattern;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activePattern = ref.watch(activeVibrationPatternProvider);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () =>
          ref.read(activeVibrationPatternProvider.notifier).setPattern(pattern),
      child: AbsorbPointer(
        child: PatternPreview(
          pattern: pattern,
          elevation: activePattern.id == pattern.id ? 200 : 2,
          child:
              activePattern.id == pattern.id ? const Icon(Icons.check) : null,
        ),
      ),
    );
  }
}
