import 'package:flutter/material.dart';

/// A custom navigation bar with a close button on the top right.
class DigilockerNavbar extends StatelessWidget implements PreferredSizeWidget {
  /// Callback invoked when the close button is pressed.
  final VoidCallback onClose;

  /// Optional title for the navbar.
  final String? title;

  /// Creates a [DigilockerNavbar] widget.
  const DigilockerNavbar({
    super.key,
    required this.onClose,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title != null ? Text(title!) : null,
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: onClose,
          tooltip: 'Close',
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
