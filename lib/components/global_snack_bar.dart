import 'package:flutter/material.dart';


enum SnackBarType {
  success,
  error,
  info,
  warning,
}

class GlobalSnackBar {
  static void show(
      BuildContext context, {
        required String message,
        SnackBarType type = SnackBarType.info,
        bool isFloating = true,
      }) {
    if (message.isEmpty) {
      return;
    }

    final snackBar = isFloating
        ? _buildFloatingSnackBar(message, type)
        : _buildTopSnackBar(message, type, context);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static SnackBar _buildTopSnackBar(
      String message, SnackBarType type, BuildContext context) {
    Color backgroundColor;
    IconData icon;
    switch (type) {
      case SnackBarType.success:
        backgroundColor = Colors.green.shade700;
        icon = Icons.check;
        break;
      case SnackBarType.error:
        backgroundColor = Colors.redAccent.shade700;
        icon = Icons.error_outline;
        break;
      case SnackBarType.info:
        backgroundColor =  Colors.black87;
        icon = Icons.info_outline;
        break;
      case SnackBarType.warning:
        backgroundColor = Colors.orange;
        icon = Icons.warning;
        break;
    }

    return SnackBar(
      duration: const Duration(seconds: 3),
      backgroundColor: backgroundColor,
      content: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            child: const Text(
              'Dismiss',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => _dismissSnackBar(context),
          ),
        ],
      ),
    );
  }

  static SnackBar _buildFloatingSnackBar(String message, SnackBarType type) {
    Color backgroundColor;
    IconData icon;
    switch (type) {
      case SnackBarType.success:
        backgroundColor = Colors.green;
        icon = Icons.check;
        break;
      case SnackBarType.error:
        backgroundColor = Colors.red.shade700;
        icon = Icons.error_outline;
        break;
      case SnackBarType.info:
        backgroundColor = Colors.black87;
        icon = Icons.info_outline;
        break;
      case SnackBarType.warning:
        backgroundColor = Colors.orange;
        icon = Icons.warning;
        break;
    }

    return SnackBar(
      duration: const Duration(seconds: 3),
      backgroundColor: backgroundColor,
      content: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  static void _dismissSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}
