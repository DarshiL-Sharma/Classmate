import 'package:flutter/material.dart';
import '../consoleConstants.dart';

/// A card that routes to the "Developer Corner".
/// Highlights the tech-focused area of the application with a gold accent border.
class DeveloperCard extends StatelessWidget {
  final VoidCallback onTap;
  const DeveloperCard({required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [DarkColors.surface, DarkColors.surfaceSoft],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: DarkColors.gold.withOpacity(0.25)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: DarkColors.gold.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.code_rounded, color: DarkColors.gold, size: 24),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Developer Corner',
                          style: TextStyle(color: DarkColors.textMain, fontSize: 15, fontWeight: FontWeight.w800)),
                      SizedBox(height: 3),
                      Text(
                        "Exclusive space designed by Developer to connect other developer",
                        style: TextStyle(color: DarkColors.textDim, fontSize: 12, height: 1.3),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: DarkColors.textFaint, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
