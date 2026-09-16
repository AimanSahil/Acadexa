import 'package:flutter/material.dart';

class BottomStatistics extends StatelessWidget {
  const BottomStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    const statistics = [
      _BottomStatData(
        title: 'Goals',
        value: '2',
        subtitle: 'Active goals',
        icon: Icons.track_changes_rounded,
      ),
      _BottomStatData(
        title: 'Subjects',
        value: '3',
        subtitle: 'Enrolled',
        icon: Icons.menu_book_rounded,
      ),
      _BottomStatData(
        title: 'Total Study Hours',
        value: '32.5',
        subtitle: 'This week',
        icon: Icons.schedule_rounded,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 700;

        if (isMobile) {
          return Column(
            children: [
              for (int i = 0; i < statistics.length; i++) ...[
                _buildCard(
                  context,
                  statistics[i],
                ),
                if (i != statistics.length - 1)
                  const SizedBox(height: 14),
              ],
            ],
          );
        }

        return Row(
          children: [
            for (int i = 0; i < statistics.length; i++) ...[
              Expanded(
                child: _buildCard(
                  context,
                  statistics[i],
                ),
              ),
              if (i != statistics.length - 1)
                const SizedBox(width: 16),
            ],
          ],
        );
      },
    );
  }

  Widget _buildCard(
    BuildContext context,
    _BottomStatData data,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return _BottomStatCard(
      data: data,
      theme: theme,
      colorScheme: colorScheme,
    );
  }
}

class _BottomStatCard extends StatefulWidget {
  final _BottomStatData data;
  final ThemeData theme;
  final ColorScheme colorScheme;

  const _BottomStatCard({
    required this.data,
    required this.theme,
    required this.colorScheme,
  });

  @override
  State<_BottomStatCard> createState() => _BottomStatCardState();
}

class _BottomStatCardState extends State<_BottomStatCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = widget.colorScheme;
    final theme = widget.theme;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() {
          _hovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          _hovered = false;
        });
      },
      child: GestureDetector(
        onTap: () {
          _showStatisticMessage(
            context,
            widget.data.title,
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          height: 128,
          padding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 18,
          ),
          transform: Matrix4.translationValues(
            0,
            _hovered ? -3 : 0,
            0,
          ),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.28,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _hovered
                  ? colorScheme.primary.withValues(
                      alpha: 0.45,
                    )
                  : colorScheme.outline.withValues(
                      alpha: 0.15,
                    ),
            ),
            boxShadow: [
              BoxShadow(
                color: _hovered
                    ? colorScheme.primary.withValues(
                        alpha: 0.10,
                      )
                    : Colors.black.withValues(
                        alpha: 0.12,
                      ),
                blurRadius: _hovered ? 26 : 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.data.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.data.value,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontSize: 27,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.7,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.data.subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.75,
                        ),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              _buildIcon(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    final colorScheme = widget.colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary.withValues(alpha: 0.24),
            colorScheme.secondary.withValues(alpha: 0.12),
          ],
        ),
        shape: BoxShape.circle,
        border: Border.all(
          color: colorScheme.primary.withValues(
            alpha: _hovered ? 0.45 : 0.25,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(
              alpha: _hovered ? 0.18 : 0.10,
            ),
            blurRadius: _hovered ? 20 : 14,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Icon(
        widget.data.icon,
        color: colorScheme.primary,
        size: 26,
      ),
    );
  }

  void _showStatisticMessage(
    BuildContext context,
    String title,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$title statistics selected.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _BottomStatData {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;

  const _BottomStatData({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
  });
}