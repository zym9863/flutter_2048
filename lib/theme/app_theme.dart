import 'package:flutter/material.dart';

class AppTheme {
  // 主色调 - 深色背景
  static const Color darkBackground = Color(0xFF0A1F3A);
  static const Color darkPurpleBackground = Color(0xFF2A0F36);
  
  // 数字块配色
  static Color getTileBackgroundColor(int value) {
    switch (value) {
      case 2: return const Color(0xFFFFF5D1);
      case 4: return const Color(0xFFFFEBA3);
      case 8: return const Color(0xFFFFB347);
      case 16: return const Color(0xFFFF6B6B);
      case 32: return const Color(0xFFFF3B6C);
      case 64: return const Color(0xFFB82E8A);
      case 128: return const Color(0xFF9B59B6);
      case 256: return const Color(0xFF6C3483);
      case 512: return const Color(0xFF00F2FE);
      case 1024: return const Color(0xFF00C9FF);
      case 2048: return const Color(0xFFFFD700);
      default: return const Color(0xFF1A2A3A); // 空方块颜色
    }
  }
  
  // 获取方块的渐变色
  static LinearGradient getTileGradient(int value) {
    switch (value) {
      case 2:
      case 4:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFF5D1), Color(0xFFFFEBA3)],
        );
      case 8:
      case 16:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFB347), Color(0xFFFF6B6B)],
        );
      case 32:
      case 64:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF3B6C), Color(0xFFB82E8A)],
        );
      case 128:
      case 256:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF9B59B6), Color(0xFF6C3483)],
        );
      case 512:
      case 1024:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF00F2FE), Color(0xFF00C9FF)],
        );
      case 2048:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
        );
      default:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A2A3A), Color(0xFF0A1F3A)],
        );
    }
  }
  
  // 辅助色
  static const Color neonBlue = Color(0xFF00F2FE);
  static const Color lightGrey = Color(0xFFE0E0E0);
  static const Color neonGreen = Color(0xFF7FFF00);
  
  // 文字颜色
  static Color getTileTextColor(int value) {
    return value <= 4 ? const Color(0xFF0A1F3A) : Colors.white;
  }
  
  // 获取文字大小
  static double getTileFontSize(int value) {
    if (value < 100) return 32.0;
    if (value < 1000) return 28.0;
    return 24.0;
  }
  
  // 获取文字样式
  static TextStyle getTileTextStyle(int value) {
    final baseStyle = TextStyle(
      color: getTileTextColor(value),
      fontSize: getTileFontSize(value),
      fontWeight: FontWeight.bold,
    );
    
    // 数值≥512添加微光描边
    if (value >= 512) {
      return baseStyle.copyWith(
        shadows: [
          Shadow(
            blurRadius: 5.0,
            color: Colors.white.withOpacity(0.5),
            offset: const Offset(0, 0),
          ),
        ],
      );
    }
    
    return baseStyle;
  }
  
  // 主题数据
  static ThemeData getThemeData() {
    return ThemeData(
      scaffoldBackgroundColor: darkBackground,
      colorScheme: ColorScheme.dark(
        primary: neonBlue,
        secondary: neonGreen,
        surface: darkBackground,
        background: darkBackground,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: darkPurpleBackground.withOpacity(0.8),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: lightGrey,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: neonBlue),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: lightGrey),
        bodyMedium: TextStyle(color: lightGrey),
      ),
      useMaterial3: true,
    );
  }
}