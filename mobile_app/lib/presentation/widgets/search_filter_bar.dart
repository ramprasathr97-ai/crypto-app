import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/search_filter_provider.dart';
import '../theme/app_theme.dart';

class SearchFilterBar extends ConsumerStatefulWidget {
  const SearchFilterBar({super.key});

  @override
  ConsumerState<SearchFilterBar> createState() => _SearchFilterBarState();
}

class _SearchFilterBarState extends ConsumerState<SearchFilterBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filterState = ref.watch(searchFilterProvider);
    final filterNotifier = ref.read(searchFilterProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          // Search Field
          TextField(
            controller: _controller,
            onChanged: (val) => filterNotifier.setSearchQuery(val),
            style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Search coin or symbol (e.g. Bitcoin, BTC)...',
              hintStyle:
                  const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
              prefixIcon:
                  const Icon(Icons.search_rounded, color: AppTheme.textSecondary),
              suffixIcon: filterState.searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded,
                          color: AppTheme.textSecondary),
                      onPressed: () {
                        _controller.clear();
                        filterNotifier.setSearchQuery('');
                      },
                    )
                  : null,
              filled: true,
              fillColor: AppTheme.surface,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppTheme.border, width: 0.8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppTheme.border, width: 0.8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppTheme.primary, width: 1.2),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildSortChip(
                  label: 'Market Cap',
                  metric: SortMetric.marketCap,
                  currentMetric: filterState.sortMetric,
                  onSelect: () => filterNotifier.setSortMetric(SortMetric.marketCap),
                ),
                const SizedBox(width: 8),
                _buildSortChip(
                  label: 'Price',
                  metric: SortMetric.price,
                  currentMetric: filterState.sortMetric,
                  onSelect: () => filterNotifier.setSortMetric(SortMetric.price),
                ),
                const SizedBox(width: 8),
                _buildSortChip(
                  label: '24h Change',
                  metric: SortMetric.change24h,
                  currentMetric: filterState.sortMetric,
                  onSelect: () => filterNotifier.setSortMetric(SortMetric.change24h),
                ),
                const SizedBox(width: 8),
                // Order Toggle Button
                InkWell(
                  onTap: () => filterNotifier.toggleSortOrder(),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.border, width: 0.8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          filterState.sortOrder == SortOrder.desc
                              ? Icons.arrow_downward_rounded
                              : Icons.arrow_upward_rounded,
                          size: 14,
                          color: AppTheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          filterState.sortOrder == SortOrder.desc
                              ? 'High-Low'
                              : 'Low-High',
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildSortChip({
    required String label,
    required SortMetric metric,
    required SortMetric currentMetric,
    required VoidCallback onSelect,
  }) {
    final isSelected = metric == currentMetric;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelect(),
      selectedColor: AppTheme.primary.withValues(alpha: 0.2),
      backgroundColor: AppTheme.surface,
      labelStyle: TextStyle(
        color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 12,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? AppTheme.primary : AppTheme.border,
          width: isSelected ? 1.2 : 0.8,
        ),
      ),
      showCheckmark: false,
    );
  }
}
