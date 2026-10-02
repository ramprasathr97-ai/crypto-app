import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'crypto_providers.dart';

class WatchlistNotifier extends StateNotifier<AsyncValue<List<String>>> {
  final Ref ref;

  WatchlistNotifier(this.ref) : super(const AsyncValue.loading()) {
    loadWatchlist();
  }

  Future<void> loadWatchlist() async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(cryptoRepositoryProvider);
      final ids = await repo.getWatchlistIds();
      state = AsyncValue.data(ids);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggleWatchlist(String coinId) async {
    try {
      final repo = ref.read(cryptoRepositoryProvider);
      await repo.toggleWatchlist(coinId);
      final updatedIds = await repo.getWatchlistIds();
      state = AsyncValue.data(updatedIds);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  bool isWatched(String coinId) {
    return state.maybeWhen(
      data: (ids) => ids.contains(coinId),
      orElse: () => false,
    );
  }
}

final watchlistProvider =
    StateNotifierProvider<WatchlistNotifier, AsyncValue<List<String>>>((ref) {
  return WatchlistNotifier(ref);
});
