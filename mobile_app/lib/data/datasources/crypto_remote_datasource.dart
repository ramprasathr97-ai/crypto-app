// Developer: Ramprasath R
// Project: Crypto Market Research App
// Module: Data Layer - Remote Data Source

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/models/coin.dart';
import '../../domain/models/coin_detail.dart';
import '../../domain/models/market_chart_data.dart';
import '../../domain/models/market_stats.dart';

/// Class responsible for performing REST API HTTP requests to the backend server.
class CryptoRemoteDataSource {
  final http.Client client;

  /// Base URL for the Node.js API server
  /// Set to local IP address so physical mobile devices and web apps connect cleanly.
  static const String baseUrl = 'https://26p48b80-3000.inc1.devtunnels.ms/api';
  

  CryptoRemoteDataSource({http.Client? client})
      : client = client ?? http.Client();

  /// Fetches cryptocurrency market items with search, sort, and ordering options
  Future<List<Coin>> fetchCoins({
    String? search,
    String? sortBy,
    String? order,
  }) async {
    final queryParams = <String, String>{};
    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    if (sortBy != null) queryParams['sortBy'] = sortBy;
    if (order != null) queryParams['order'] = order;

    final uri = Uri.parse('$baseUrl/coins').replace(
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    try {
      final response = await client.get(uri).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        if (body['success'] == true && body['data'] != null) {
          final List list = body['data'];
          return list.map((item) => Coin.fromJson(item)).toList();
        }
      }
      throw Exception('Failed to load coins: ${response.statusCode}');
    } catch (e) {
      throw Exception('Backend connection error: $e');
    }
  }

  /// Fetches detailed metrics and statistics for a specific coin ID
  Future<CoinDetail> fetchCoinDetail(String coinId) async {
    final uri = Uri.parse('$baseUrl/coins/$coinId');

    try {
      final response = await client.get(uri).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        if (body['success'] == true && body['data'] != null) {
          return CoinDetail.fromJson(body['data']);
        }
      }
      throw Exception('Failed to load coin details for $coinId');
    } catch (e) {
      throw Exception('Error loading coin detail: $e');
    }
  }

  /// Fetches historical price chart data points for the given time range (days)
  Future<List<MarketChartPoint>> fetchMarketChart(
      String coinId, int days) async {
    final uri = Uri.parse('$baseUrl/coins/$coinId/market_chart?days=$days');

    try {
      final response = await client.get(uri).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        if (body['success'] == true && body['prices'] != null) {
          final List prices = body['prices'];
          return prices.map((item) => MarketChartPoint.fromList(item)).toList();
        }
      }
      throw Exception('Failed to load chart prices');
    } catch (e) {
      throw Exception('Error loading chart data: $e');
    }
  }

  /// Fetches overall global crypto market statistics
  Future<GlobalMarketStats> fetchGlobalStats() async {
    final uri = Uri.parse('$baseUrl/global');

    try {
      final response = await client.get(uri).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        if (body['success'] == true && body['data'] != null) {
          return GlobalMarketStats.fromJson(body['data']);
        }
      }
      throw Exception('Failed to load global market stats');
    } catch (e) {
      throw Exception('Error loading global stats: $e');
    }
  }
}
