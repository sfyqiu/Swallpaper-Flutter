import 'package:flutter/material.dart';

/// Swallpaper Liquid Glass Design System
/// Replicates macOS V3 Liquid Glass visual style for Flutter (Windows + Android)

class AppColors {
  // Brand primary colors
  static const Color primaryPink = Color(0xFFFF3366);
  static const Color secondaryViolet = Color(0xFF8B5CF6);
  static const Color tertiaryBlue = Color(0xFF3B8BFF);
  static const Color accentCyan = Color(0xFF00D4FF);
  static const Color accentOrange = Color(0xFFFF6B35);
  static const Color onlineGreen = Color(0xFF34D399);
  static const Color warningOrange = Color(0xFFFF9F43);

  // Background (dark mode)
  static const Color deepBackground = Color(0xFF0D0D0D);
  static const Color midBackground = Color(0xFF12121F);
  static const Color surfaceBackground = Color(0xFF1A1A2E);
  static const Color elevatedBackground = Color(0xFF1E1E28);

  // Glass effects
  static Color glassWhite = Colors.white.withValues(alpha: 0.26);
  static Color glassWhiteLight = Colors.white.withValues(alpha: 0.34);
  static Color glassWhiteSubtle = Colors.white.withValues(alpha: 0.16);
  static Color glassBorder = Colors.white.withValues(alpha: 0.34);
  static Color glassBorderLight = Colors.white.withValues(alpha: 0.46);
  static Color glassWhiteStrong = Colors.white.withValues(alpha: 0.42);
  static Color glassTint = Colors.white.withValues(alpha: 0.12);
  static Color glassHighlight = Colors.white.withValues(alpha: 0.7);
  static Color glassHighlightSubtle = Colors.white.withValues(alpha: 0.4);

  // Text colors (dark mode)
  static const Color textPrimary = Colors.white;
  static Color textSecondary = Colors.white.withValues(alpha: 0.7);
  static Color textTertiary = Colors.white.withValues(alpha: 0.5);
  static Color textQuaternary = Colors.white.withValues(alpha: 0.3);

  // Borders
  static Color borderSubtle = Colors.white.withValues(alpha: 0.1);
  static Color borderDefault = Colors.white.withValues(alpha: 0.2);
  static Color borderStrong = Colors.white.withValues(alpha: 0.3);

  // Glow colors
  static Color glowPink = const Color(0xFFFF3B6B).withValues(alpha: 0.4);
  static Color glowViolet = const Color(0xFF9D6FFF).withValues(alpha: 0.4);
  static Color glowBlue = const Color(0xFF3B8BFF).withValues(alpha: 0.4);

  // Player bar
  static const Color playerBarBackground = Color(0xFF232A36);
  static const Color playerBarBackgroundLight = Color(0xFF2A313F);
  static Color playerBarBorder = Colors.white.withValues(alpha: 0.15);

  // Gradients
  static const List<Color> heroGradient = [
    Color(0x33000000),
    Color(0x99000000),
  ];
  static const List<Color> glassCardGradient = [
    Color(0x1AFFFFFF),
    Color(0x0DFFFFFF),
  ];
}

class AppRadius {
  static const double xs = 8;
  static const double small = 12;
  static const double medium = 20;
  static const double large = 28;
  static const double extraLarge = 36;
  static const double capsule = 9999;
}

class AppPadding {
  static const double xs = 4;
  static const double small = 8;
  static const double medium = 12;
  static const double standard = 16;
  static const double large = 20;
  static const double xl = 24;
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.deepBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryPink,
        secondary: AppColors.secondaryViolet,
        tertiary: AppColors.tertiaryBlue,
        surface: AppColors.surfaceBackground,
        error: AppColors.warningOrange,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: AppColors.textPrimary),
        titleSmall: TextStyle(color: AppColors.textSecondary),
        bodyLarge: TextStyle(color: AppColors.textPrimary),
        bodyMedium: TextStyle(color: AppColors.textSecondary),
        bodySmall: TextStyle(color: AppColors.textTertiary),
        labelLarge: TextStyle(color: AppColors.textPrimary),
        labelMedium: TextStyle(color: AppColors.textSecondary),
        labelSmall: TextStyle(color: AppColors.textTertiary),
      ),
      cardTheme: CardThemeData(
        color: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.medium)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: AppColors.textPrimary,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.midBackground,
        elevation: 0,
        indicatorColor: AppColors.primaryPink.withValues(alpha: 0.2),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(color: AppColors.primaryPink, fontSize: 12);
          }
          return const TextStyle(color: AppColors.textSecondary, fontSize: 12);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primaryPink);
          }
          return const IconThemeData(color: AppColors.textTertiary);
        }),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.glassTint,
        labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        selectedColor: AppColors.primaryPink.withValues(alpha: 0.3),
        secondarySelectedColor: AppColors.primaryPink,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.capsule)),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.glassTint,
        hintStyle: const TextStyle(color: AppColors.textTertiary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: const BorderSide(color: AppColors.borderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          borderSide: const BorderSide(color: AppColors.primaryPink, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.borderSubtle,
        thickness: 0.5,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceBackground,
        contentTextStyle: const TextStyle(color: AppColors.textPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.small)),
        behavior: SnackBarBehavior.floating,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.midBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.large)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.medium)),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primaryPink;
          return AppColors.textTertiary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primaryPink.withValues(alpha: 0.4);
          return AppColors.borderDefault;
        }),
      ),
    );
  }
}

/// Glass card container widget matching macOS V3 style
class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final Color? borderColor;
  final Color? backgroundColor;
  final double? height;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = AppRadius.medium,
    this.padding = const EdgeInsets.all(16),
    this.borderColor,
    this.backgroundColor,
    this.height,
    this.onTap,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.glassTint,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor ?? AppColors.borderSubtle,
          width: 0.5,
        ),
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: card,
        ),
      );
    }
    return card;
  }
}

/// Glass button with Liquid Glass styling
class GlassButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final Color? color;
  final bool isPill;
  final double height;

  const GlassButton({
    super.key,
    required this.label,
    this.icon,
    this.onTap,
    this.color,
    this.isPill = false,
    this.height = 44,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(isPill ? AppRadius.capsule : AppRadius.small),
        child: Container(
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: color ?? AppColors.primaryPink.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(isPill ? AppRadius.capsule : AppRadius.small),
            border: Border.all(
              color: (color ?? AppColors.primaryPink).withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: AppColors.textPrimary, size: 16),
                const SizedBox(width: 8),
              ],
              Text(label, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Glass search bar
class GlassSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;

  const GlassSearchBar({
    super.key,
    required this.controller,
    this.hintText = 'Search...',
    this.onSubmitted,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.glassTint,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: AppColors.textTertiary),
          prefixIcon: Icon(Icons.search, color: AppColors.textTertiary, size: 20),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.close, color: AppColors.textTertiary, size: 18),
                  onPressed: () {
                    controller.clear();
                    onClear?.call();
                  },
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        textInputAction: TextInputAction.search,
        onSubmitted: onSubmitted,
      ),
    );
  }
}

/// Atmospheric background with animated gradient circles
class GlassAtmosphereBackground extends StatelessWidget {
  final Widget child;

  const GlassAtmosphereBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.deepBackground,
            AppColors.midBackground,
            AppColors.surfaceBackground,
            AppColors.deepBackground,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Decorative glow orbs
          Positioned(
            top: -100,
            right: -50,
            child: _GlowOrb(color: AppColors.glowPink, size: 300),
          ),
          Positioned(
            bottom: -80,
            left: -60,
            child: _GlowOrb(color: AppColors.glowViolet, size: 250),
          ),
          Positioned(
            top: 200,
            left: -30,
            child: _GlowOrb(color: AppColors.glowBlue.withValues(alpha: 0.2), size: 200),
          ),
          child,
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final Color color;
  final double size;

  const _GlowOrb({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        blurStyle: BlurStyle.normal,
      ),
    );
  }
}
