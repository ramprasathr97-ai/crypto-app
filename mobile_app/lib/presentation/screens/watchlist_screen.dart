import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/crypto_providers.dart';
import '../widgets/coin_card.dart';
import '../widgets/state_widgets.dart';

class WatchlistScreen extends ConsumerWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final watchlistCoinsAsync = ref.watch(watchlistCoinsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.star_rounded, color: Colors.amber, size: 24),
            SizedBox(width: 8),
            Text(
              'My Watchlist',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(coinListProvider);
        },
        child: watchlistCoinsAsync.when(
          data: (coins) {
            if (coins.isEmpty) {
              return const CryptoEmptyWidget(
                title: 'Your Watchlist is Empty',
                subtitle:
                    'Tap the star icon ⭐ on any coin to save it to your personal watchlist.',
                icon: Icons.star_border_rounded,
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: coins.length,
              itemBuilder: (context, index) {
                return CoinCard(coin: coins[index]);
              },
            );
          },
          loading: () => const CryptoLoadingWidget(),
          error: (err, stack) => CryptoErrorWidget(
            message: err.toString(),
            onRetry: () => ref.invalidate(coinListProvider),
          ),
        ),
      ),
    );
  }
}
