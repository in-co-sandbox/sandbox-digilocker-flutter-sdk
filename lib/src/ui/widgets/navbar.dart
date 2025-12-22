import 'package:flutter/material.dart';

/// A custom navigation bar with a close button on the top right
class DigilockerNavbar extends StatelessWidget implements PreferredSizeWidget {
  /// Callback invoked when the close button is pressed.
  final VoidCallback onClose;

  /// Optional title for the navbar.
  final String? title;

  /// Theme options containing seed color and mode
  final Map<String, dynamic>? themeOptions;

  /// Creates a [DigilockerNavbar] widget.
  const DigilockerNavbar({
    super.key,
    required this.onClose,
    this.title,
    this.themeOptions,
  });

  @override
  Widget build(BuildContext context) {
    // Get color scheme from theme options or fallback to context theme
    final colorScheme = _getColorScheme(context);

    return AppBar(
      titleSpacing: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: true,
      backgroundColor: colorScheme.surface,
      title: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 56, width: 56),
              Expanded(
                child: Text(
                  title ?? '',
                  style: _getTitleTextStyle(colorScheme),
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                padding: const EdgeInsets.all(16),
                icon: Icon(Icons.close, size: 24, color: colorScheme.onSurface),
                onPressed: onClose,
                tooltip: 'Close',
              ),
            ],
          ),
          Divider(height: 1, color: colorScheme.outlineVariant),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  /// Get color scheme from theme options or fallback to context theme
  ColorScheme _getColorScheme(BuildContext context) {
    if (themeOptions != null && themeOptions!.containsKey('theme')) {
      final theme = themeOptions!['theme'] as Map<String, dynamic>?;
      if (theme != null) {
        final seedColor = _fromHex(theme['seed']);
        final brightness = theme['mode'] as String == 'dark' ? Brightness.dark : Brightness.light;
        return ColorScheme.fromSeed(seedColor: seedColor, brightness: brightness);
      }
    }
    return Theme.of(context).colorScheme;
  }

  static Color _fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  TextStyle _getTitleTextStyle(ColorScheme colorScheme) {
    return TextStyle(
        fontWeight: FontWeight.w400, fontSize: 14, height: 20 / 14, letterSpacing: 0, color: colorScheme.onSurface);
  }
}
