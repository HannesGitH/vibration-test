import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Review {
  static final instance = Review._();

  DateTime? _lastRequested;

  static const _key = 'review_requested';

  Review._() {
    _loadLastRequested();
  }

  Future<void> _loadLastRequested() async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    instance._lastRequested = DateTime.fromMillisecondsSinceEpoch(
      p.getInt(_key) ?? 0,
    );
  }

  Future<void> _saveLastRequested() async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    await p.setInt(_key, DateTime.now().millisecondsSinceEpoch);
  }

  static Future<void> request() async {
    final InAppReview inAppReview = InAppReview.instance;
    final lastRequested = instance._lastRequested;
    await instance._loadLastRequested();
    if (lastRequested!.isBefore(
          DateTime.now().subtract(const Duration(days: 30)),
        ) &&
        await inAppReview.isAvailable()) {
      inAppReview.requestReview();
      await instance._saveLastRequested();
    }
  }
}
