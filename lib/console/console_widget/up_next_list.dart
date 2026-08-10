import 'package:flutter/material.dart';
import '../consoleConstants.dart';

/// Data model for an item in the Up Next list.
class UpNextItem {
  final String title;
  final String meta;
  final IconData icon;
  final String url;
  UpNextItem({required this.title, required this.meta, required this.icon, required this.url});
}

/// A vertical list of upcoming tasks or links.
/// Each item is tappable and opens an external link.
class UpNextList extends StatelessWidget {
  final List<UpNextItem> items;
  final Function(String) onLinkTap;
  const UpNextList({required this.items, required this.onLinkTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(items.length, (index) {
        final item = items[index];
        return Column(
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onLinkTap(item.url),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      Icon(item.icon, color: DarkColors.textDim, size: 20),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.title,
                                style: const TextStyle(color: DarkColors.textMain, fontSize: 14, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 2),
                            Text(item.meta, style: const TextStyle(color: DarkColors.textDim, fontSize: 12)),
                          ],
                        ),
                      ),
                      const Icon(Icons.open_in_new_rounded, color: DarkColors.textFaint, size: 18),
                    ],
                  ),
                ),
              ),
            ),
            if (index != items.length - 1)
              Divider(height: 1, color: Colors.white.withOpacity(0.06)),
          ],
        );
      }),
    );
  }
}
