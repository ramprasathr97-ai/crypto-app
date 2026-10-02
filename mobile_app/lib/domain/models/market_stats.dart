class GlobalMarketStats {
  final int activeCryptocurrencies;
  final double totalMarketCapUsd;
  final double totalVolume24hUsd;
  final double marketCapChangePercentage24hUsd;
  final double bitcoinDominance;
  final double ethereumDominance;

  GlobalMarketStats({
    required this.activeCryptocurrencies,
    required this.totalMarketCapUsd,
    required this.totalVolume24hUsd,
    required this.marketCapChangePercentage24hUsd,
    required this.bitcoinDominance,
    required this.ethereumDominance,
  });

  factory GlobalMarketStats.fromJson(Map<String, dynamic> json) {
    return GlobalMarketStats(
      activeCryptocurrencies:
          (json['active_cryptocurrencies'] as num?)?.toInt() ?? 0,
      totalMarketCapUsd:
          (json['total_market_cap_usd'] as num?)?.toDouble() ?? 0.0,
      totalVolume24hUsd:
          (json['total_volume_24h_usd'] as num?)?.toDouble() ?? 0.0,
      marketCapChangePercentage24hUsd:
          (json['market_cap_change_percentage_24h_usd'] as num?)?.toDouble() ??
              0.0,
      bitcoinDominance:
          (json['bitcoin_dominance'] as num?)?.toDouble() ?? 0.0,
      ethereumDominance:
          (json['ethereum_dominance'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
