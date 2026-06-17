import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wallpaper_provider.dart';

class SourceChips extends StatelessWidget {
  const SourceChips({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WallpaperProvider>(
      builder: (context, provider, child) {
        final sources = provider.sourceNames;
        if (sources.isEmpty) return const SizedBox.shrink();

        return SizedBox(
          height: 48,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: sources.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final source = sources[index];
              final isSelected = source == provider.currentSource;

              return ChoiceChip(
                label: Text(source),
                selected: isSelected,
                onSelected: (_) => provider.setSource(source),
                showCheckmark: false,
              );
            },
          ),
        );
      },
    );
  }
}
