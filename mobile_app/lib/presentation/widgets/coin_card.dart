import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/models/coin.dart';
import '../providers/watchlist_provider.dart';
import '../screens/coin_detail_screen.dart';
import '../theme/app_theme.dart';

class CoinCard extends ConsumerWidget {
  final Coin coin;

  const CoinCard({super.key, required this.coin});

  String _formatPrice(double price) {
    if (price >= 1.0) {
      return NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(price);
    } else {
      return NumberFormat.currency(symbol: '\$', decimalDigits: 4).format(price);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final watchlistNotifier = ref.read(watchlistProvider.notifier);
    final isWatched = watchlistNotifier.isWatched(coin.id);
    final isPositive = coin.priceChangePercentage24h >= 0;
    final changeColor = isPositive ? AppTheme.positive : AppTheme.negative;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CoinDetailScreen(coinId: coin.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Rank
              SizedBox(
                width: 24,
                child: Text(
                  '${coin.marketCapRank}',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Icon Image
              Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(right: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    coin.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppTheme.surfaceLight,
                      child: const Icon(Icons.currency_bitcoin,
                          color: AppTheme.primary),
                    ),
                  ),
                ),
              ),
              // Name & Symbol
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coin.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      coin.symbol,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              // Price & 24h Change
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatPrice(coin.currentPrice),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: changeColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isPositive
                              ? Icons.arrow_drop_up_rounded
                              : Icons.arrow_drop_down_rounded,
                          size: 16,
                          color: changeColor,
                        ),
                        Text(
                          '${coin.priceChangePercentage24h.abs().toStringAsFixed(2)}%',
                          style: TextStyle(
                            color: changeColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              // Watchlist Star Button
              IconButton(
                icon: Icon(
                  isWatched ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: isWatched ? Colors.amber : AppTheme.textSecondary,
                  size: 24,
                ),
                onPressed: () {
                  watchlistNotifier.toggleWatchlist(coin.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
