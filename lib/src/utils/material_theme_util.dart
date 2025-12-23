import 'package:flutter/material.dart';

/// Utility class for Material theme operations
class MaterialThemeUtil {
  /// Get color scheme from theme options or fallback to context theme
  static ColorScheme getColorScheme(
    BuildContext context,
    Map<String, dynamic>? themeOptions,
  ) {
    if (themeOptions != null && themeOptions.containsKey('theme')) {
      final theme = themeOptions['theme'] as Map<String, dynamic>?;
      if (theme != null) {
        final seedColor = _fromHex(theme['seed']);
        final brightness = theme['mode'] as String == 'dark' ? Brightness.dark : Brightness.light;
        return ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: brightness,
          dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
        );
      }
    }
    return Theme.of(context).colorScheme;
  }

  /// Convert hex string to Color
  static Color _fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Get Material Design 3 text theme
  static TextTheme getTextTheme() {
    return TextTheme(
      bodyMedium:
          TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w500, fontSize: 14, height: 20 / 14, letterSpacing: 0),
    );
  }
}
