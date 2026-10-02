import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/crypto_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/state_widgets.dart';

class MarketStatsScreen extends ConsumerWidget {
  const MarketStatsScreen({super.key});

  String _formatCurrency(double value) {
    return NumberFormat.currency(symbol: '\$', decimalDigits: 0).format(value);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final globalStatsAsync = ref.watch(globalStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.pie_chart_rounded, color: AppTheme.accent, size: 24),
            SizedBox(width: 8),
            Text(
              'Market Analytics',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(globalStatsProvider);
        },
        child: globalStatsAsync.when(
          data: (stats) {
            final isPositive = stats.marketCapChangePercentage24hUsd >= 0;
            final changeColor = isPositive ? AppTheme.positive : AppTheme.negative;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Total Market Cap Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.surface,
                          AppTheme.surfaceLight.withValues(alpha: 0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.border, width: 0.8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Crypto Market Cap',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _formatCurrency(stats.totalMarketCapUsd),
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: changeColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isPositive
                                        ? Icons.arrow_drop_up_rounded
                                        : Icons.arrow_drop_down_rounded,
                                    color: changeColor,
                                    size: 18,
                                  ),
                                  Text(
                                    '${stats.marketCapChangePercentage24hUsd.abs().toStringAsFixed(2)}% in 24h',
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Key Metrics Grid
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricTile(
                          title: '24h Trading Vol',
                          value: NumberFormat.compactCurrency(symbol: '\$')
                              .format(stats.totalVolume24hUsd),
                          icon: Icons.graphic_eq_rounded,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildMetricTile(
                          title: 'Active Cryptos',
                          value: NumberFormat().format(stats.activeCryptocurrencies),
                          icon: Icons.token_rounded,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Dominance Visual Progress Bars
                  const Text(
                    'Market Dominance',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _buildDominanceCard(
                    symbol: 'BTC',
                    name: 'Bitcoin Dominance',
                    percentage: stats.bitcoinDominance,
                    color: Colors.amber,
                  ),
                  const SizedBox(height: 12),
                  _buildDominanceCard(
                    symbol: 'ETH',
                    name: 'Ethereum Dominance',
                    percentage: stats.ethereumDominance,
                    color: Colors.blueAccent,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
          loading: () => const CryptoLoadingWidget(),
          error: (err, stack) => CryptoErrorWidget(
            message: err.toString(),
            onRetry: () => ref.invalidate(globalStatsProvider),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricTile({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.primary, size: 22),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDominanceCard({
    required String symbol,
    required String name,
    required double percentage,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                '${percentage.toStringAsFixed(2)}%',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: (percentage / 100).clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: AppTheme.surfaceLight,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}
