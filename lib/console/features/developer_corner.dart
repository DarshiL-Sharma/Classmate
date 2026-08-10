import 'package:flutter/material.dart';
import '../consoleConstants.dart';

class DeveloperCornerPage extends StatelessWidget {
  const DeveloperCornerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DarkColors.bg,
      appBar: AppBar(
        title: const Text('Developer Corner', style: TextStyle(color: DarkColors.textMain)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: DarkColors.textMain),
      ),
      body: const Center(
        child: Text('Developer Corner Content', style: TextStyle(color: DarkColors.textDim)),
      ),
    );
  }
}
