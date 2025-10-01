import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibrationtest/extensions/list.dart';
import 'package:vibrationtest/generated/l10n.dart';

import '../models/vibration/vibration.dart';
import '../widgets/patternGallery.dart';

class PatternGalleryPage extends ConsumerWidget {
  const PatternGalleryPage({
    super.key,
    this.elemsPerRow = 2,
  });
  final int elemsPerRow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patterns = ref.watch(allPatternsProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(S.of(context).presetTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ListView.builder(
          itemCount: (patterns.length ~/ elemsPerRow) + 3,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0 || index == patterns.length ~/ elemsPerRow + 5) {
              return const SizedBox(height: 10.0);
            }
            index -= 1;
            return Row(
              mainAxisSize: MainAxisSize.max,
              children: List.generate(elemsPerRow, (i) {
                final pattern = patterns.safeAt(index * elemsPerRow + i);
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: pattern == null
                        ? Container()
                        : GalleryPatternPreview(pattern: pattern),
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}
