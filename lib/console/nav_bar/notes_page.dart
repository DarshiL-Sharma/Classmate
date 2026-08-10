import 'package:flutter/material.dart';
import '../consoleConstants.dart';

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DarkColors.bg,
      appBar: AppBar(
        title: const Text('Notes & Docs', style: TextStyle(color: DarkColors.textMain)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: DarkColors.textMain),
      ),
      body: const Center(
        child: Text('Notes & Docs Content', style: TextStyle(color: DarkColors.textDim)),
      ),
    );
  }
}
