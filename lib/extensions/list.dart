extension SaveList<T> on List<T> {
  T? safeAt(idx) {
    try {
      return this[idx];
    } catch (e) {
      return null;
    }
  }

  List<T> safeSublist(int start, [int? end]) {
    start = start.clamp(0, length);
    end = end?.clamp(start, length);
    try {
      return sublist(start, end);
    } catch (e) {
      return [];
    }
  }
}

class Tuple<T, E> {
  final T e1;
  final E e2;

  Tuple(this.e1, this.e2);
}

extension Search<T> on List<T> {
  ///the List has to be sorted already
  Tuple<int, num> indexOfClosest(num Function(T) distanceTo) {
    int factor = 1;
    int divider = 1;
    int prevStep = 0;
    num smallestDistance = double.maxFinite;
    num currentDistance = 0;
    while (divider <= length || currentDistance.abs() < smallestDistance) {
      divider *= 2;
      currentDistance = distanceTo(this[length * factor ~/ divider]);
      if (currentDistance.abs() <= smallestDistance)
        smallestDistance = currentDistance.abs();
      if (currentDistance == 0) break;
      factor -= prevStep;
      factor *= 2;
      prevStep = currentDistance < 0 ? 1 : -1;
      factor += prevStep;
    }
    return Tuple(
        length * (factor -= prevStep) ~/ (divider * 2), currentDistance);
  }
}
