import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/crypto_providers.dart';
import '../providers/watchlist_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/price_chart.dart';
import '../widgets/state_widgets.dart';

class CoinDetailScreen extends ConsumerWidget {
  final String coinId;

  const CoinDetailScreen({super.key, required this.coinId});

  String _formatCurrency(double value) {
    if (value >= 1.0) {
      return NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(value);
    } else {
      return NumberFormat.currency(symbol: '\$', decimalDigits: 4).format(value);
    }
  }

  String _formatCompact(double? value) {
    if (value == null || value == 0) return '∞ / N/A';
    return NumberFormat.compact().format(value);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coinDetailAsync = ref.watch(coinDetailProvider(coinId));
    final selectedDays = ref.watch(selectedChartDaysProvider);
    final chartDataAsync = ref.watch(
      marketChartProvider(ChartArgs(coinId: coinId, days: selectedDays)),
    );
    final watchlistNotifier = ref.read(watchlistProvider.notifier);
    final isWatched = watchlistNotifier.isWatched(coinId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coin Research Details'),
        actions: [
          IconButton(
            icon: Icon(
              isWatched ? Icons.star_rounded : Icons.star_outline_rounded,
              color: isWatched ? Colors.amber : AppTheme.textSecondary,
              size: 28,
            ),
            onPressed: () {
              watchlistNotifier.toggleWatchlist(coinId);
            },
          ),
        ],
      ),
      body: coinDetailAsync.when(
        data: (detail) {
          final isPositive = detail.priceChangePercentage24h >= 0;
          final changeColor = isPositive ? AppTheme.positive : AppTheme.negative;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Details
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.network(
                        detail.image,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 50,
                          height: 50,
                          color: AppTheme.surfaceLight,
                          child: const Icon(Icons.currency_bitcoin,
                              color: AppTheme.primary, size: 30),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                detail.name,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppTheme.surfaceLight,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '#${detail.marketCapRank}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.textSecondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            detail.symbol,
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Current Price & 24h Change
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      _formatCurrency(detail.currentPrice),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: changeColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isPositive
                                ? Icons.arrow_drop_up_rounded
                                : Icons.arrow_drop_down_rounded,
                            size: 20,
                            color: changeColor,
                          ),
                          Text(
                            '${detail.priceChangePercentage24h.abs().toStringAsFixed(2)}%',
                            style: TextStyle(
                              color: changeColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Interactive Chart Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Price Performance',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Time Frame Selector Chips (1D, 7D, 30D)
                    Row(
                      children: [1, 7, 30].map((days) {
                        final isSelected = selectedDays == days;
                        return GestureDetector(
                          onTap: () {
                            ref
                                .read(selectedChartDaysProvider.notifier)
                                .state = days;
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 6),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.primary
                                  : AppTheme.surface,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected
                                    ? AppTheme.primary
                                    : AppTheme.border,
                                width: 0.8,
                              ),
                            ),
                            child: Text(
                              '${days}D',
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.black
                                    : AppTheme.textSecondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // Price Line Chart
                chartDataAsync.when(
                  data: (points) => InteractivePriceChart(
                    points: points,
                    isPositive: isPositive,
                  ),
                  loading: () => Container(
                    height: 250,
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                        child: CircularProgressIndicator(
                            color: AppTheme.primary)),
                  ),
                  error: (err, _) => Container(
                    height: 250,
                    alignment: Alignment.center,
                    child: Text('Chart error: $err'),
                  ),
                ),
                const SizedBox(height: 28),
                // Market Statistics Grid
                const Text(
                  'Market Statistics',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 2.2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: [
                    _buildStatCard(
                      label: 'Market Cap',
                      value: NumberFormat.compactCurrency(symbol: '\$')
                          .format(detail.marketCap),
                      icon: Icons.pie_chart_outline_rounded,
                    ),
                    _buildStatCard(
                      label: '24h Trading Volume',
                      value: NumberFormat.compactCurrency(symbol: '\$')
                          .format(detail.totalVolume),
                      icon: Icons.bar_chart_rounded,
                    ),
                    _buildStatCard(
                      label: 'Circulating Supply',
                      value:
                          '${_formatCompact(detail.circulatingSupply)} ${detail.symbol}',
                      icon: Icons.loop_rounded,
                    ),
                    _buildStatCard(
                      label: 'Total Supply',
                      value:
                          '${_formatCompact(detail.totalSupply)} ${detail.symbol}',
                      icon: Icons.account_balance_wallet_outlined,
                    ),
                    _buildStatCard(
                      label: '24h High / Low',
                      value:
                          '${_formatCurrency(detail.high24h)} / ${_formatCurrency(detail.low24h)}',
                      icon: Icons.swap_vert_rounded,
                    ),
                    _buildStatCard(
                      label: 'All-Time High (ATH)',
                      value: _formatCurrency(detail.ath),
                      icon: Icons.workspace_premium_rounded,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
        loading: () => const CryptoLoadingWidget(),
        error: (err, stack) => CryptoErrorWidget(
          message: err.toString(),
          onRetry: () => ref.invalidate(coinDetailProvider(coinId)),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border, width: 0.8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppTheme.primary, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
