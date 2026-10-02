import '../models/coin.dart';
import '../models/coin_detail.dart';
import '../models/market_chart_data.dart';
import '../models/market_stats.dart';

abstract class CryptoRepository {
  Future<List<Coin>> getCoins({
    String? search,
    String? sortBy,
    String? order,
  });

  Future<CoinDetail> getCoinDetail(String coinId);

  Future<List<MarketChartPoint>> getMarketChart(String coinId, int days);

  Future<GlobalMarketStats> getGlobalStats();

  Future<List<String>> getWatchlistIds();

  Future<void> toggleWatchlist(String coinId);
}
