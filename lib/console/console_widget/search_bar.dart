import 'package:flutter/material.dart';
import '../consoleConstants.dart';

/// A modern, interactive search bar.
/// Features an elastic spring animation on focus and a dynamic background shift.
class ModernSearchBar extends StatefulWidget {
  const ModernSearchBar({super.key});

  @override
  State<ModernSearchBar> createState() => _ModernSearchBarState();
}

class _ModernSearchBarState extends State<ModernSearchBar> {
  final FocusNode _focusNode = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() => _focused = _focusNode.hasFocus));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _focusNode.requestFocus(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.elasticOut,
        height: 54,
        margin: EdgeInsets.symmetric(horizontal: _focused ? 0 : 6),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: _focused ? Colors.white.withOpacity(0.92) : DarkColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _focused ? Colors.transparent : Colors.white.withOpacity(0.05),
          ),
          boxShadow: _focused
              ? [
            BoxShadow(
              color: DarkColors.gold.withOpacity(0.25),
              blurRadius: 20,
              spreadRadius: 1,
            ),
          ]
              : [],
        ),
        child: Row(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Icon(
                Icons.search,
                key: ValueKey(_focused),
                color: _focused ? DarkColors.coral : DarkColors.textDim,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: TextField(
                focusNode: _focusNode,
                style: TextStyle(color: _focused ? Colors.black87 : DarkColors.textMain, fontSize: 14),
                cursorColor: DarkColors.coral,
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: "Search your query...",
                  hintStyle: TextStyle(
                    color: _focused ? Colors.black38 : DarkColors.textDim,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Icon(Icons.mic_none_rounded,
                color: _focused ? DarkColors.coral : DarkColors.textDim, size: 20),
          ],
        ),
      ),
    );
  }
}
