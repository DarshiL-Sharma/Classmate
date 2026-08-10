import 'package:flutter/material.dart';
import '../consoleConstants.dart';

class SurpriseDetailsPage extends StatelessWidget {
  const SurpriseDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DarkColors.bg,
      appBar: AppBar(
        title: const Text('Surprise Details', style: TextStyle(color: DarkColors.textMain)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: DarkColors.textMain),
      ),
      body: const Center(
        child: Text('Surprise Details Content', style: TextStyle(color: DarkColors.textDim)),
      ),
    );
  }
}
