import 'package:flutter/material.dart';
import '../consoleConstants.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DarkColors.bg,
      appBar: AppBar(
        title: const Text('Results', style: TextStyle(color: DarkColors.textMain)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: DarkColors.textMain),
      ),
      body: const Center(
        child: Text('Results Content', style: TextStyle(color: DarkColors.textDim)),
      ),
    );
  }
}
