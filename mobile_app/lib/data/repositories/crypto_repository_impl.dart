import '../../domain/models/coin.dart';
import '../../domain/models/coin_detail.dart';
import '../../domain/models/market_chart_data.dart';
import '../../domain/models/market_stats.dart';
import '../../domain/repositories/crypto_repository.dart';
import '../datasources/crypto_remote_datasource.dart';
import '../datasources/watchlist_local_datasource.dart';

class CryptoRepositoryImpl implements CryptoRepository {
  final CryptoRemoteDataSource remoteDataSource;
  final WatchlistLocalDataSource localDataSource;

  CryptoRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Coin>> getCoins({
    String? search,
    String? sortBy,
    String? order,
  }) {
    return remoteDataSource.fetchCoins(
      search: search,
      sortBy: sortBy,
      order: order,
    );
  }

  @override
  Future<CoinDetail> getCoinDetail(String coinId) {
    return remoteDataSource.fetchCoinDetail(coinId);
  }

  @override
  Future<List<MarketChartPoint>> getMarketChart(String coinId, int days) {
    return remoteDataSource.fetchMarketChart(coinId, days);
  }

  @override
  Future<GlobalMarketStats> getGlobalStats() {
    return remoteDataSource.fetchGlobalStats();
  }

  @override
  Future<List<String>> getWatchlistIds() {
    return localDataSource.getWatchlistIds();
  }

  @override
  Future<void> toggleWatchlist(String coinId) async {
    await localDataSource.toggleWatchlist(coinId);
  }
}
