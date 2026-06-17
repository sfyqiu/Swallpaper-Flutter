import 'package:flutter/material.dart';
import '../../config/theme.dart';

/// Reusable chip row for source selection
class ChipRow extends StatelessWidget {
  final List<String> items;
  final String selected;
  final void Function(String) onSelected;

  const ChipRow({
    super.key,
    required this.items,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final item = items[i];
          final isSelected = item == selected;
          return ChoiceChip(
            label: Text(item, style: TextStyle(
              fontSize: 13,
              color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
            )),
            selected: isSelected,
            onSelected: (_) => onSelected(item),
            showCheckmark: false,
            backgroundColor: AppColors.glassTint,
            selectedColor: AppColors.primaryPink.withValues(alpha: 0.3),
            side: BorderSide(
              color: isSelected ? AppColors.primaryPink.withValues(alpha: 0.5) : AppColors.borderSubtle,
              width: isSelected ? 1.0 : 0.5,
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.capsule)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          );
        },
      ),
    );
  }
}
