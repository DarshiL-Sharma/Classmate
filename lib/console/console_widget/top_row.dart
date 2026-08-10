import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../consoleConstants.dart';

/// The header row of the home screen.
/// Includes an animated avatar, a personalized greeting, and a notification icon.
class TopRow extends StatefulWidget {
  final VoidCallback onProfileTap;
  const TopRow({required this.onProfileTap, super.key});

  @override
  State<TopRow> createState() => _TopRowState();
}

class _TopRowState extends State<TopRow> with SingleTickerProviderStateMixin {
  late final AnimationController _bounce = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );
  late final Animation<double> _scaleX = TweenSequence([
    TweenSequenceItem(tween: Tween(begin: 0.6, end: 1.18), weight: 35),
    TweenSequenceItem(tween: Tween(begin: 1.18, end: 0.92), weight: 25),
    TweenSequenceItem(tween: Tween(begin: 0.92, end: 1.0), weight: 40),
  ]).animate(CurvedAnimation(parent: _bounce, curve: Curves.easeOut));
  late final Animation<double> _scaleY = TweenSequence([
    TweenSequenceItem(tween: Tween(begin: 1.3, end: 0.85), weight: 35),
    TweenSequenceItem(tween: Tween(begin: 0.85, end: 1.08), weight: 25),
    TweenSequenceItem(tween: Tween(begin: 1.08, end: 1.0), weight: 40),
  ]).animate(CurvedAnimation(parent: _bounce, curve: Curves.easeOut));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bounce.forward());
  }

  @override
  void dispose() {
    _bounce.dispose();
    super.dispose();
  }

  String _greetingName() {
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName?.trim();
    if (displayName != null && displayName.isNotEmpty) {
      return displayName.split(' ').first;
    }
    final email = user?.email;
    if (email != null && email.contains('@')) {
      return email.split('@').first;
    }
    return 'there';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: widget.onProfileTap,
          child: AnimatedBuilder(
            animation: _bounce,
            builder: (context, child) => Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..scale(_scaleX.value, _scaleY.value),
              child: child,
            ),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                gradient: DarkColors.coralGoldGradient,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.15)),
              ),
              child: const Icon(Icons.person_rounded, color: Colors.white, size: 22),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: 'Hey, ', style: TextStyle(color: DarkColors.textDim, fontSize: 13)),
                TextSpan(
                  text: _greetingName(),
                  style: const TextStyle(color: DarkColors.textMain, fontSize: 17, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
        ),
        const Icon(Icons.notifications_none_rounded, color: DarkColors.textDim, size: 24),
      ],
    );
  }
}
