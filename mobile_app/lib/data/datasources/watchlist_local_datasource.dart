import 'package:shared_preferences/shared_preferences.dart';

class WatchlistLocalDataSource {
  static const _key = 'crypto_watchlist_ids';

  Future<List<String>> getWatchlistIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? ['bitcoin', 'ethereum'];
  }

  Future<void> saveWatchlistIds(List<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, ids);
  }

  Future<bool> toggleWatchlist(String coinId) async {
    final list = await getWatchlistIds();
    final updated = List<String>.from(list);
    bool isAdded = false;
    if (updated.contains(coinId)) {
      updated.remove(coinId);
      isAdded = false;
    } else {
      updated.add(coinId);
      isAdded = true;
    }
    await saveWatchlistIds(updated);
    return isAdded;
  }
}
