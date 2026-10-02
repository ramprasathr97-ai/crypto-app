class MarketChartPoint {
  final DateTime timestamp;
  final double price;

  MarketChartPoint({
    required this.timestamp,
    required this.price,
  });

  factory MarketChartPoint.fromList(List<dynamic> list) {
    final ms = (list[0] as num).toInt();
    final priceVal = (list[1] as num).toDouble();
    return MarketChartPoint(
      timestamp: DateTime.fromMillisecondsSinceEpoch(ms),
      price: priceVal,
    );
  }
}
