part of '../../digilocker_sdk.dart';

/// A custom navigation bar with a close button on the top right
class _DigilockerNavbar extends StatelessWidget implements PreferredSizeWidget {
  /// Callback invoked when the close button is pressed.
  final VoidCallback onClose;

  /// Optional title for the navbar.
  final String? title;

  /// Theme options containing seed color and mode
  final Map<String, dynamic>? themeOptions;

  /// Creates a [_DigilockerNavbar] widget.
  const _DigilockerNavbar({
    required this.onClose,
    this.title,
    this.themeOptions,
  });

  @override
  Widget build(BuildContext context) {
    // Get color scheme from theme options or fallback to context theme
    final colorScheme = MaterialThemeUtil.getColorScheme(context, themeOptions);
    final textTheme = MaterialThemeUtil.getTextTheme();

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
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: colorScheme.onSurface,
                  ),
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
}
