import 'package:flutter/material.dart';
import '../consoleConstants.dart';

class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DarkColors.bg,
      appBar: AppBar(
        title: const Text('Notification Preferences', style: TextStyle(color: DarkColors.textMain)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: DarkColors.textMain),
      ),
      body: const Center(
        child: Text('Notification Preferences Content', style: TextStyle(color: DarkColors.textDim)),
      ),
    );
  }
}
