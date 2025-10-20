import 'package:flutter/material.dart';

class UrlBar extends StatelessWidget {
  const UrlBar({
    super.key,
    required this.controller,
    required this.onSubmit,
    required this.isPrivate,
    required this.onPrivateToggle,
  });

  final TextEditingController controller;
  final ValueChanged<String> onSubmit;
  final bool isPrivate;
  final VoidCallback onPrivateToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFF151521),
        border: Border(bottom: BorderSide(color: Color(0xFF2d1b4c))),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: onSubmit,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock, color: Colors.white.withOpacity(0.6)),
                hintText: 'Enter URL or search query',
              ),
            ),
          ),
          const SizedBox(width: 12),
          Tooltip(
            message: isPrivate ? 'Disable private mode' : 'Enable private mode',
            child: IconButton(
              icon: Icon(isPrivate ? Icons.visibility_off : Icons.visibility),
              onPressed: onPrivateToggle,
            ),
          ),
        ],
      ),
    );
  }
}
