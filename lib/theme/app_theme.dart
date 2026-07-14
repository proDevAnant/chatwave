import 'package:flutter/material.dart';

class AppColors {
  static const Color primary     = Color(0xFF2AABEE);
  static const Color primaryDark = Color(0xFF1E96D4);
  static const Color accent      = Color(0xFF7C4DFF);
  static const Color scaffold    = Color(0xFFF3F6FB);
  static const Color bubbleIn    = Colors.white;
  static const Color textDark    = Color(0xFF14202E);
  static const Color textLight   = Color(0xFF8A97A8);
  static const Color online      = Color(0xFF31D158);
  static const Color chatBg      = Color(0xFFEAF2F8);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF37B4F5), Color(0xFF2091D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient outgoingGradient = LinearGradient(
    colors: [Color(0xFF41BEFA), Color(0xFF2AABEE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const List<List<Color>> avatarGradients = [
    [Color(0xFF2AABEE), Color(0xFF1E96D4)],
    [Color(0xFFF5487F), Color(0xFFE0356B)],
    [Color(0xFF7C4DFF), Color(0xFF5E2FE0)],
    [Color(0xFF00BFA5), Color(0xFF009E88)],
    [Color(0xFFFF8A00), Color(0xFFFF6D00)],
    [Color(0xFF00C853), Color(0xFF00A344)],
  ];
}

class AppTheme {
  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.scaffold,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.primary,
        secondary: AppColors.accent,
      ),
      // default system font (Roboto) — clean aur fast
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        systemOverlayStyle: null,
      ),
    );
  }
}
