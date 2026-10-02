import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SortMetric { marketCap, price, change24h }
enum SortOrder { desc, asc }

class SearchFilterState {
  final String searchQuery;
  final SortMetric sortMetric;
  final SortOrder sortOrder;

  SearchFilterState({
    this.searchQuery = '',
    this.sortMetric = SortMetric.marketCap,
    this.sortOrder = SortOrder.desc,
  });

  SearchFilterState copyWith({
    String? searchQuery,
    SortMetric? sortMetric,
    SortOrder? sortOrder,
  }) {
    return SearchFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      sortMetric: sortMetric ?? this.sortMetric,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  String get sortByQueryParam {
    switch (sortMetric) {
      case SortMetric.price:
        return 'price';
      case SortMetric.change24h:
        return 'change';
      case SortMetric.marketCap:
        return 'market_cap';
    }
  }

  String get orderQueryParam => sortOrder == SortOrder.asc ? 'asc' : 'desc';
}

class SearchFilterNotifier extends StateNotifier<SearchFilterState> {
  SearchFilterNotifier() : super(SearchFilterState());

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setSortMetric(SortMetric metric) {
    state = state.copyWith(sortMetric: metric);
  }

  void toggleSortOrder() {
    final nextOrder =
        state.sortOrder == SortOrder.desc ? SortOrder.asc : SortOrder.desc;
    state = state.copyWith(sortOrder: nextOrder);
  }

  void reset() {
    state = SearchFilterState();
  }
}

final searchFilterProvider =
    StateNotifierProvider<SearchFilterNotifier, SearchFilterState>((ref) {
  return SearchFilterNotifier();
});
