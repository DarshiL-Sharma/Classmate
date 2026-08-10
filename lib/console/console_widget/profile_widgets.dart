import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../consoleConstants.dart';


class ProfileSheetAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;
  const ProfileSheetAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? DarkColors.red : DarkColors.textMain;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 14),
              Text(label, style: TextStyle(color: color, fontSize: 14.5, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

void showProfileSheet({
  required BuildContext context,
  required VoidCallback onAccountSettings,
  required VoidCallback onNotificationSettings,
  required VoidCallback onLogout,
}) {
  final user = FirebaseAuth.instance.currentUser;
  final name = (user?.displayName?.isNotEmpty ?? false) ? user!.displayName! : '';
  final email = user?.email ?? 'No email on file';

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (sheetContext) {
      return Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        decoration: const BoxDecoration(
          color: DarkColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: DarkColors.surfaceSoft,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  child: const Icon(Icons.person_rounded, color: DarkColors.textDim, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: const TextStyle(
                              color: DarkColors.textMain, fontSize: 16, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 2),
                      Text(email, style: const TextStyle(color: DarkColors.textDim, fontSize: 12.5)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Divider(height: 1, color: Colors.white.withOpacity(0.06)),
            const SizedBox(height: 4),
            ProfileSheetAction(
              icon: Icons.settings_rounded,
              label: 'Account settings',
              onTap: onAccountSettings,
            ),
            ProfileSheetAction(
              icon: Icons.notifications_none_rounded,
              label: 'Notification preferences',
              onTap: onNotificationSettings,
            ),
            ProfileSheetAction(
              icon: Icons.logout_rounded,
              label: 'Log out',
              isDestructive: true,
              onTap: onLogout,
            ),
          ],
        ),
      );
    },
  );
}
