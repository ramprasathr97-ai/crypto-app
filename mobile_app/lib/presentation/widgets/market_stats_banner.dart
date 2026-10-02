import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/models/market_stats.dart';
import '../theme/app_theme.dart';

class MarketStatsBanner extends StatelessWidget {
  final GlobalMarketStats stats;

  const MarketStatsBanner({super.key, required this.stats});

  String _formatCompact(double number) {
    return NumberFormat.compactCurrency(symbol: '\$').format(number);
  }

  @override
  Widget build(BuildContext context) {
    final isPositive = stats.marketCapChangePercentage24hUsd >= 0;
    final changeColor = isPositive ? AppTheme.positive : AppTheme.negative;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.surface,
            AppTheme.surfaceLight.withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.query_stats_rounded,
                      color: AppTheme.primary, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Global Crypto Market',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
                      size: 16,
                      color: changeColor,
                    ),
                    Text(
                      '${stats.marketCapChangePercentage24hUsd.abs().toStringAsFixed(2)}% 24h',
                      style: TextStyle(
                        color: changeColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatTile(
                label: 'Market Cap',
                value: _formatCompact(stats.totalMarketCapUsd),
              ),
              _buildStatTile(
                label: '24h Volume',
                value: _formatCompact(stats.totalVolume24hUsd),
              ),
              _buildStatTile(
                label: 'BTC Dominance',
                value: '${stats.bitcoinDominance.toStringAsFixed(1)}%',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatTile({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
