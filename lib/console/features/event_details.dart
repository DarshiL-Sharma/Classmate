import 'package:flutter/material.dart';
import '../consoleConstants.dart';

class EventDetailsPage extends StatelessWidget {
  const EventDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DarkColors.bg,
      appBar: AppBar(
        title: const Text('Event Details', style: TextStyle(color: DarkColors.textMain)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: DarkColors.textMain),
      ),
      body: const Center(
        child: Text('Event Details Content', style: TextStyle(color: DarkColors.textDim)),
      ),
    );
  }
}
