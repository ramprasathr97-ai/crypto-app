import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/crypto_remote_datasource.dart';
import '../../data/datasources/watchlist_local_datasource.dart';
import '../../data/repositories/crypto_repository_impl.dart';
import '../../domain/models/coin.dart';
import '../../domain/models/coin_detail.dart';
import '../../domain/models/market_chart_data.dart';
import '../../domain/models/market_stats.dart';
import '../../domain/repositories/crypto_repository.dart';
import 'search_filter_provider.dart';
import 'watchlist_provider.dart';

// Repository Provider
final cryptoRepositoryProvider = Provider<CryptoRepository>((ref) {
  return CryptoRepositoryImpl(
    remoteDataSource: CryptoRemoteDataSource(),
    localDataSource: WatchlistLocalDataSource(),
  );
});

// Coin List Provider with Auto-Refresh & Filters
final coinListProvider = FutureProvider<List<Coin>>((ref) async {
  final repository = ref.watch(cryptoRepositoryProvider);
  final filterState = ref.watch(searchFilterProvider);

  return repository.getCoins(
    search: filterState.searchQuery,
    sortBy: filterState.sortByQueryParam,
    order: filterState.orderQueryParam,
  );
});

// Watchlist Coins Provider
final watchlistCoinsProvider = FutureProvider<List<Coin>>((ref) async {
  final coinsAsync = await ref.watch(coinListProvider.future);
  final watchlistIdsAsync = ref.watch(watchlistProvider);

  final watchlistIds = watchlistIdsAsync.maybeWhen(
    data: (ids) => ids,
    orElse: () => <String>[],
  );

  return coinsAsync.where((coin) => watchlistIds.contains(coin.id)).toList();
});

// Coin Detail Provider
final coinDetailProvider =
    FutureProvider.family<CoinDetail, String>((ref, coinId) async {
  final repository = ref.watch(cryptoRepositoryProvider);
  return repository.getCoinDetail(coinId);
});

// Selected Chart Days State (1, 7, 30)
final selectedChartDaysProvider = StateProvider<int>((ref) => 7);

// Market Chart Data Provider
class ChartArgs {
  final String coinId;
  final int days;
  ChartArgs({required this.coinId, required this.days});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChartArgs &&
          runtimeType == other.runtimeType &&
          coinId == other.coinId &&
          days == other.days;

  @override
  int get hashCode => coinId.hashCode ^ days.hashCode;
}

final marketChartProvider =
    FutureProvider.family<List<MarketChartPoint>, ChartArgs>((ref, args) async {
  final repository = ref.watch(cryptoRepositoryProvider);
  return repository.getMarketChart(args.coinId, args.days);
});

// Global Market Stats Provider
final globalStatsProvider = FutureProvider<GlobalMarketStats>((ref) async {
  final repository = ref.watch(cryptoRepositoryProvider);
  return repository.getGlobalStats();
});
