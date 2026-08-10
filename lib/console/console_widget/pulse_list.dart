import 'package:flutter/material.dart';
import '../consoleConstants.dart';

/// Data model for an item in the Community Pulse feed.
class PulseItem {
  final String author;
  final String text;
  final String time;
  final String url;
  PulseItem({required this.author, required this.text, required this.time, required this.url});
}

/// A list representing the "Community Pulse" (News Feed).
/// Each item displays the author, content, and relative time of the update.
class PulseList extends StatelessWidget {
  final List<PulseItem> items;
  final Function(String) onLinkTap;
  const PulseList({required this.items, required this.onLinkTap, super.key});

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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: const BoxDecoration(color: DarkColors.surfaceSoft, shape: BoxShape.circle),
                        child: const Icon(Icons.verified_rounded, color: DarkColors.gold, size: 16),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(item.author,
                                    style: const TextStyle(color: DarkColors.textMain, fontSize: 13, fontWeight: FontWeight.w700)),
                                const SizedBox(width: 6),
                                Text('· ${item.time}', style: const TextStyle(color: DarkColors.textFaint, fontSize: 12)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(item.text, style: const TextStyle(color: DarkColors.textDim, fontSize: 13, height: 1.3)),
                          ],
                        ),
                      ),
                      const Icon(Icons.open_in_new_rounded, color: DarkColors.textFaint, size: 16),
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
