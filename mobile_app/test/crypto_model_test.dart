import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/domain/models/coin.dart';
import 'package:mobile_app/domain/models/market_stats.dart';

void main() {
  group('Crypto Model Unit Tests', () {
    test('Coin.fromJson parses correctly', () {
      final json = {
        'id': 'bitcoin',
        'symbol': 'btc',
        'name': 'Bitcoin',
        'image': 'https://example.com/btc.png',
        'current_price': 65000.5,
        'market_cap': 1200000000000,
        'market_cap_rank': 1,
        'total_volume': 25000000000,
        'high_24h': 66000.0,
        'low_24h': 64000.0,
        'price_change_24h': 1000.5,
        'price_change_percentage_24h': 1.55,
        'circulating_supply': 19700000,
        'total_supply': 21000000,
        'max_supply': 21000000,
        'ath': 73000.0,
        'sparkline_in_7d': {
          'price': [64000.0, 64500.0, 65000.5]
        }
      };

      final coin = Coin.fromJson(json);

      expect(coin.id, equals('bitcoin'));
      expect(coin.symbol, equals('BTC'));
      expect(coin.name, equals('Bitcoin'));
      expect(coin.currentPrice, equals(65000.5));
      expect(coin.marketCapRank, equals(1));
      expect(coin.sparkline7d.length, equals(3));
    });

    test('GlobalMarketStats.fromJson parses correctly', () {
      final json = {
        'active_cryptocurrencies': 15000,
        'total_market_cap_usd': 2400000000000.0,
        'total_volume_24h_usd': 80000000000.0,
        'market_cap_change_percentage_24h_usd': 2.5,
        'bitcoin_dominance': 54.2,
        'ethereum_dominance': 16.8
      };

      final stats = GlobalMarketStats.fromJson(json);

      expect(stats.activeCryptocurrencies, equals(15000));
      expect(stats.bitcoinDominance, equals(54.2));
      expect(stats.ethereumDominance, equals(16.8));
    });
  });
}
