import 'package:flutter/material.dart';

class FeatureCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color accentColor;
  final VoidCallback? onTap;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.accentColor,
    this.onTap,
  });

  @override
  State<FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,

      onEnter: (_) {
        setState(() {
          isHovered = true;
        });
      },

      onExit: (_) {
        setState(() {
          isHovered = false;
        });
      },

      child: GestureDetector(
        onTap: widget.onTap,

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,

          // Slightly smaller padding
          padding: const EdgeInsets.all(18),

          transform: isHovered
              ? Matrix4.translationValues(0, -3, 0)
              : Matrix4.identity(),

          decoration: BoxDecoration(
            // Dark card background
            color: const Color(0xFF080D22),

            borderRadius: BorderRadius.circular(14),

            // Accent border
            border: Border.all(
              color: isHovered
                  ? widget.accentColor.withValues(alpha: 0.75)
                  : widget.accentColor.withValues(alpha: 0.32),
              width: 1,
            ),

            // Glow when hovered
            boxShadow: isHovered
                ? [
                    BoxShadow(
                      color: widget.accentColor.withValues(
                        alpha: 0.12,
                      ),
                      blurRadius: 22,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),

          child: Stack(
            children: [
              
              // MAIN CONTENT
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
    
                  // ICON
                   Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: widget.accentColor.withValues(
                        alpha: 0.16,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      widget.icon,
                      color: widget.accentColor,
                      size: 22,
                    ),
                  ),

                  const SizedBox(height: 13),

                  // TITLE
                  Text(
                    widget.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 7),

                  // DESCRIPTION
                  Padding(
                    // Keep description away from arrow
                    padding: const EdgeInsets.only(
                      right: 28,
                    ),
                    child: Text(
                      widget.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFFA8AEC3),
                        fontSize: 13,
                        height: 1.45,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),

              // =================================================
              // ARROW
              // =================================================

              Positioned(
                right: 0,
                bottom: 0,
                child: AnimatedSlide(
                  duration: const Duration(
                    milliseconds: 180,
                  ),
                  offset: isHovered
                      ? const Offset(0.15, 0)
                      : Offset.zero,
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: widget.accentColor,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}