import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/crypto_providers.dart';
import '../widgets/coin_card.dart';
import '../widgets/market_stats_banner.dart';
import '../widgets/search_filter_bar.dart';
import '../widgets/state_widgets.dart';

class CoinListScreen extends ConsumerWidget {
  const CoinListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coinsAsync = ref.watch(coinListProvider);
    final globalStatsAsync = ref.watch(globalStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.greenAccent.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.show_chart_rounded,
                  color: Colors.greenAccent, size: 22),
            ),
            const SizedBox(width: 10),
            const Text(
              'Crypto Market',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(coinListProvider);
          ref.invalidate(globalStatsProvider);
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // Global Market Stats Header Banner
            SliverToBoxAdapter(
              child: globalStatsAsync.when(
                data: (stats) => MarketStatsBanner(stats: stats),
                loading: () => const SizedBox.shrink(),
                error: (err, stack) => const SizedBox.shrink(),
              ),
            ),
            // Search & Sorting Bar
            const SliverToBoxAdapter(
              child: SearchFilterBar(),
            ),
            // Coin List / States
            coinsAsync.when(
              data: (coins) {
                if (coins.isEmpty) {
                  return const SliverFillRemaining(
                    child: CryptoEmptyWidget(
                      title: 'No Cryptocurrencies Found',
                      subtitle: 'Try searching with another symbol or name.',
                    ),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => CoinCard(coin: coins[index]),
                      childCount: coins.length,
                    ),
                  ),
                );
              },
              loading: () => const SliverFillRemaining(
                child: CryptoLoadingWidget(),
              ),
              error: (err, stack) => SliverFillRemaining(
                child: CryptoErrorWidget(
                  message: err.toString(),
                  onRetry: () {
                    ref.invalidate(coinListProvider);
                    ref.invalidate(globalStatsProvider);
                  },
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }
}
