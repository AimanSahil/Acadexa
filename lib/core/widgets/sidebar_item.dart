import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class SidebarItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final bool selected;
  final VoidCallback onTap;
  final bool collapsed;

  const SidebarItem({
    super.key,
    required this.icon,
    required this.title,
    required this.selected,
    required this.onTap,
    this.collapsed = false,
  });

  @override
  State<SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<SidebarItem> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final bool active = widget.selected;

    final Color iconColor = active
        ? Colors.white
        : (_hovering
            ? AppColors.secondary
            : AppColors.textSecondary);

    final Color textColor = active
        ? Colors.white
        : (_hovering
            ? Colors.white
            : AppColors.textSecondary);

    Widget item = MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() {
          _hovering = true;
        });
      },
      onExit: (_) {
        setState(() {
          _hovering = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        margin: EdgeInsets.symmetric(
          horizontal: widget.collapsed ? 10 : 12,
          vertical: 3,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: widget.collapsed ? 0 : 12,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          gradient: active
              ? const LinearGradient(
                  colors: [
                    Color(0xFF7C3AED),
                    Color(0xFF9333EA),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : (_hovering
                  ? LinearGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.12),
                        AppColors.secondary.withValues(alpha: 0.06),
                      ],
                    )
                  : null),
          borderRadius: BorderRadius.circular(9),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.28),
                    blurRadius: 14,
                    spreadRadius: -5,
                  ),
                ]
              : null,
        ),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(9),
          child: SizedBox(
            height: 20,
            child: Row(
              mainAxisAlignment: widget.collapsed
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                Icon(
                  widget.icon,
                  size: 17,
                  color: iconColor,
                ),
                if (!widget.collapsed) ...[
                  const SizedBox(width: 11),
                  Expanded(
                    child: Text(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 12.5,
                        fontWeight:
                            active ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );

    if (widget.collapsed) {
      return Tooltip(
        message: widget.title,
        child: item,
      );
    }

    return item;
  }
}