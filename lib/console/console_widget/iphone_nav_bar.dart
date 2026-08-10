import 'dart:ui';
import 'package:flutter/material.dart';
import '../consoleConstants.dart';

/// A stylized bottom navigation bar inspired by iOS.
/// Features a "jelly-slide" pill animation that stretches and snaps to the active tab.
class IPhoneNavBar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  const IPhoneNavBar({required this.selectedIndex, required this.onTap, super.key});

  @override
  State<IPhoneNavBar> createState() => _IPhoneNavBarState();
}

class _IPhoneNavBarState extends State<IPhoneNavBar> with SingleTickerProviderStateMixin {
  late final AnimationController _jelly = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );
  late final Animation<double> _stretch = TweenSequence([
    TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.45), weight: 40),
    TweenSequenceItem(tween: Tween(begin: 1.45, end: 0.9), weight: 30),
    TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.0), weight: 30),
  ]).animate(CurvedAnimation(parent: _jelly, curve: Curves.easeOut));

  final items = const [
    (icon: Icons.grid_view_rounded, label: 'Home'),
    (icon: Icons.forum_outlined, label: 'Community'),
    (icon: Icons.folder_outlined, label: 'Notes'),
  ];

  @override
  void dispose() {
    _jelly.dispose();
    super.dispose();
  }

  void _handleTap(int index) {
    if (index != widget.selectedIndex) _jelly.forward(from: 0);
    widget.onTap(index);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(70, 0, 70, 28),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            height: 56,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: DarkColors.navBg.withOpacity(0.55),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withOpacity(0.10), width: 0.8),
            ),
            child: Stack(
              children: [
                AnimatedBuilder(
                  animation: _stretch,
                  builder: (context, child) {
                    return AnimatedAlign(
                      duration: const Duration(milliseconds: 420),
                      curve: Curves.easeOutExpo,
                      alignment: Alignment(
                          -1.0 + (widget.selectedIndex * (2.0 / (items.length - 1))), 0),
                      child: Transform.scale(
                        scaleX: _stretch.value,
                        scaleY: 2 - _stretch.value,
                        child: child,
                      ),
                    );
                  },
                  child: FractionallySizedBox(
                    widthFactor: 1 / items.length,
                    child: Container(
                      decoration: BoxDecoration(
                        color: DarkColors.navActivePill,
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: List.generate(items.length, (index) {
                    final isSelected = index == widget.selectedIndex;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => _handleTap(index),
                        behavior: HitTestBehavior.opaque,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                items[index].icon,
                                color: isSelected ? Colors.white : DarkColors.textDim,
                                size: 20,
                              ),
                              if (isSelected) ...[
                                const SizedBox(height: 2),
                                Text(
                                  items[index].label,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
