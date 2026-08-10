import 'package:flutter/material.dart';
import '../consoleConstants.dart';

class HallTicketPage extends StatelessWidget {
  const HallTicketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DarkColors.bg,
      appBar: AppBar(
        title: const Text('Hall Ticket', style: TextStyle(color: DarkColors.textMain)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: DarkColors.textMain),
      ),
      body: const Center(
        child: Text('Hall Ticket Content', style: TextStyle(color: DarkColors.textDim)),
      ),
    );
  }
}
