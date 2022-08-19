import 'package:flutter/material.dart';
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

class GalleryPatternPreview extends ConsumerStatefulWidget {
  const GalleryPatternPreview({required this.pattern, super.key});
  final VibrationPattern pattern;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GalleryPatternPreviewState();
}

class _GalleryPatternPreviewState extends ConsumerState<GalleryPatternPreview> {
  bool isDown = false;
  bool showOptions = false;

  @override
  Widget build(BuildContext context) {
    final activePattern = ref.watch(activeVibrationPatternProvider);
    return Hero(
      tag: widget.pattern.id,
      child: AnimatedContainer(
        transform: Matrix4.rotationX(showOptions ? -1.2 : (isDown ? -0.5 : 0)),
        duration: const Duration(milliseconds: 400),
        child: Opacity(
          opacity: isDown ? 0.5 : 1.0,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (details) => setState(() {
              isDown = true;
            }),
            onTapUp: (details) => setState(() {
              isDown = false;
            }),
            onTapCancel: () => setState(() {
              isDown = false;
            }),
            onLongPress: () {
              //TODO: show options like delete, rename, etc.
              // showOptions ^= true;
            },
            onTap: () => ref
                .read(activeVibrationPatternProvider.notifier)
                .setPattern(widget.pattern),
            child: AbsorbPointer(
              child: PatternPreview(
                pattern: widget.pattern,
                elevation: activePattern.id == widget.pattern.id ? 200 : 2,
                child: activePattern.id == widget.pattern.id
                    ? const Icon(Icons.check)
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
