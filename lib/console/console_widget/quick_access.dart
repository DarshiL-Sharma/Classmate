import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../consoleConstants.dart';

/// Data model for an item in the Quick Access grid.
class QuickAccessItem {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  QuickAccessItem({required this.label, required this.icon, required this.color, this.onTap});
}

/// A horizontally scrollable row of Quick Access tiles.
/// Connects to a rotation listener for subtle parallax effects during scroll.
class QuickAccessRow extends StatelessWidget {
  final List<QuickAccessItem> items;
  final ValueListenable<double> rotation;
  const QuickAccessRow({required this.items, required this.rotation, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 18),
        itemBuilder: (context, index) => QuickAccessTile(item: items[index], rotation: rotation),
      ),
    );
  }
}

/// An individual Quick Access button.
/// Features a "jiggle" animation on press and a 3D flip animation on tap.
class QuickAccessTile extends StatefulWidget {
  final QuickAccessItem item;
  final ValueListenable<double> rotation;
  const QuickAccessTile({required this.item, required this.rotation, super.key});

  @override
  State<QuickAccessTile> createState() => _QuickAccessTileState();
}

class _QuickAccessTileState extends State<QuickAccessTile> with TickerProviderStateMixin {
  bool _pressed = false;
  late final AnimationController _flip = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );

  @override
  void dispose() {
    _flip.dispose();
    super.dispose();
  }

  void _handleTap() {
    _flip.forward(from: 0);
    widget.item.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      child: Column(
        children: [
          GestureDetector(
            onTapDown: (_) => setState(() => _pressed = true),
            onTapCancel: () => setState(() => _pressed = false),
            onTapUp: (_) => setState(() => _pressed = false),
            onTap: _handleTap,
            child: AnimatedScale(
              scale: _pressed ? 0.86 : 1.0,
              duration: const Duration(milliseconds: 110),
              curve: _pressed ? Curves.easeOut : Curves.elasticOut,
              child: ValueListenableBuilder<double>(
                valueListenable: widget.rotation,
                builder: (context, angle, child) => Transform.rotate(angle: angle, child: child),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: widget.item.color,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: widget.item.color.withOpacity(0.45),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: AnimatedBuilder(
                    animation: _flip,
                    builder: (context, child) {
                      final angle = _flip.value * 2 * math.pi;
                      return Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.002)
                          ..rotateY(angle),
                        child: child,
                      );
                    },
                    child: Icon(widget.item.icon, color: Colors.white, size: 24),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.item.label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: DarkColors.textDim, fontSize: 11.5),
          ),
        ],
      ),
    );
  }
}
