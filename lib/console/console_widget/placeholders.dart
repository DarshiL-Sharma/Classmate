import 'package:flutter/material.dart';
import '../consoleConstants.dart';

class FeaturePlaceholderPage extends StatelessWidget {
  final String title;
  const FeaturePlaceholderPage({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DarkColors.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(title, style: const TextStyle(color: DarkColors.textMain)),
        iconTheme: const IconThemeData(color: DarkColors.textMain),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.hourglass_top_rounded, color: DarkColors.gold, size: 36),
            const SizedBox(height: 16),
            Text('$title is coming soon',
                style: const TextStyle(color: DarkColors.textDim, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class PlaceholderTab extends StatelessWidget {
  final String label;
  final IconData icon;
  const PlaceholderTab({required this.label, required this.icon, super.key});
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('$label coming soon', 
          style: const TextStyle(color: DarkColors.textDim)),
    );
  }
}
