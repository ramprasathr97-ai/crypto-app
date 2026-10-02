import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../domain/models/coin.dart';
import '../../domain/models/coin_detail.dart';
import '../../domain/models/market_chart_data.dart';
import '../../domain/models/market_stats.dart';

class CryptoRemoteDataSource {
  final http.Client client;

  CryptoRemoteDataSource({http.Client? client})
      : client = client ?? http.Client();

  // Dynamic base URLs for Web, Physical Mobile (192.168.1.17), Emulator (10.0.2.2), & Localhost
  List<String> get candidateBaseUrls {
    if (kIsWeb) {
      return ['http://localhost:3000/api', 'http://127.0.0.1:3000/api'];
    }
    if (Platform.isAndroid || Platform.isIOS) {
      return [
        'http://192.168.1.17:3000/api', // Physical Android/iOS phone over Wi-Fi
        'http://10.0.2.2:3000/api',     // Android Emulator
        'http://localhost:3000/api',    // ADB reverse
      ];
    }
    return ['http://localhost:3000/api', 'http://127.0.0.1:3000/api'];
  }

  Future<http.Response> _getWithFallback(String endpoint, {Map<String, String>? queryParams}) async {
    Object? lastError;
    for (final base in candidateBaseUrls) {
      try {
        final uri = Uri.parse('$base$endpoint').replace(queryParameters: queryParams);
        final response = await client.get(uri).timeout(const Duration(seconds: 4));
        if (response.statusCode == 200) {
          return response;
        }
      } catch (e) {
        lastError = e;
      }
    }
    throw Exception('Unable to connect to backend server (Tried ${candidateBaseUrls.join(', ')}). Error: $lastError');
  }

  Future<List<Coin>> fetchCoins({
    String? search,
    String? sortBy,
    String? order,
  }) async {
    final queryParams = <String, String>{};
    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    if (sortBy != null) queryParams['sortBy'] = sortBy;
    if (order != null) queryParams['order'] = order;

    try {
      final response = await _getWithFallback('/coins', queryParams: queryParams.isNotEmpty ? queryParams : null);
      final body = json.decode(response.body);
      if (body['success'] == true && body['data'] != null) {
        final List list = body['data'];
        return list.map((item) => Coin.fromJson(item)).toList();
      }
      throw Exception('Failed to load coins: ${response.statusCode}');
    } catch (e) {
      throw Exception('Backend connection error: $e');
    }
  }

  Future<CoinDetail> fetchCoinDetail(String coinId) async {
    try {
      final response = await _getWithFallback('/coins/$coinId');
      final body = json.decode(response.body);
      if (body['success'] == true && body['data'] != null) {
        return CoinDetail.fromJson(body['data']);
      }
      throw Exception('Failed to load coin details for $coinId');
    } catch (e) {
      throw Exception('Error loading coin detail: $e');
    }
  }

  Future<List<MarketChartPoint>> fetchMarketChart(
      String coinId, int days) async {
    try {
      final response = await _getWithFallback('/coins/$coinId/market_chart', queryParams: {'days': '$days'});
      final body = json.decode(response.body);
      if (body['success'] == true && body['prices'] != null) {
        final List prices = body['prices'];
        return prices.map((item) => MarketChartPoint.fromList(item)).toList();
      }
      throw Exception('Failed to load chart prices');
    } catch (e) {
      throw Exception('Error loading chart data: $e');
    }
  }

  Future<GlobalMarketStats> fetchGlobalStats() async {
    try {
      final response = await _getWithFallback('/global');
      final body = json.decode(response.body);
      if (body['success'] == true && body['data'] != null) {
        return GlobalMarketStats.fromJson(body['data']);
      }
      throw Exception('Failed to load global market stats');
    } catch (e) {
      throw Exception('Error loading global stats: $e');
    }
  }
}
