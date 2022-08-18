part of 'local.dart';

const PATTERN_COLLECTION_NAME = 'patterns';
final patternStore = db.collection(PATTERN_COLLECTION_NAME);

Future<void> savePattern(VibrationPattern pattern) async {
  await patternStore.doc(pattern.id).set(pattern.toJson());
}

Future<void> deletePattern(VibrationPattern pattern) async {
  await patternStore.doc(pattern.id).delete();
}

Future<List<VibrationPattern>> getAllPatterns() async {
  final snapshot = (await patternStore.get())?.values;
  return snapshot
          ?.map((doc) => VibrationPattern.fromJson(doc.data()))
          .toList() ??
      const [];
}

Future<List<String>> getAllPatternNames() async {
  final snapshot = (await patternStore.get())?.keys;
  return snapshot?.toList() ?? const [];
}

Future<VibrationPattern?> getPattern(String id) async {
  final snapshot = (await patternStore.doc(id).get());
  return snapshot == null ? null : VibrationPattern.fromJson(snapshot);
}
