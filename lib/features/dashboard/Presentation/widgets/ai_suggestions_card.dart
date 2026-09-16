import 'package:flutter/material.dart';

class AiSuggestionsCard extends StatelessWidget {
  const AiSuggestionsCard({super.key});

  static const List<_SuggestionData> _suggestions = [
    _SuggestionData(
      title: 'Review Data Structures',
      description:
          "You've been inactive in this subject for 3 days.",
      icon: Icons.menu_book_rounded,
    ),
    _SuggestionData(
      title: 'Focus on Weak Topics',
      description:
          'Dynamic Programming needs more practice.',
      icon: Icons.trending_up_rounded,
    ),
    _SuggestionData(
      title: 'Pomodoro Focus Session',
      description:
          'Start a 25-minute focus session now.',
      icon: Icons.timer_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.28,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outline.withValues(
            alpha: 0.16,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.12,
            ),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(
              context,
              theme,
              colorScheme,
            ),
            const SizedBox(height: 16),
            ...List.generate(
              _suggestions.length,
              (index) => Padding(
                padding: EdgeInsets.only(
                  bottom: index == _suggestions.length - 1
                      ? 0
                      : 10,
                ),
                child: _SuggestionItem(
                  suggestion: _suggestions[index],
                  index: index,
                ),
              ),
            ),
            const SizedBox(height: 17),
            _buildViewMoreButton(
              context,
              colorScheme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primary.withValues(
                  alpha: 0.25,
                ),
                colorScheme.secondary.withValues(
                  alpha: 0.18,
                ),
              ],
            ),
            borderRadius: BorderRadius.circular(11),
            border: Border.all(
              color: colorScheme.primary.withValues(
                alpha: 0.25,
              ),
            ),
          ),
          child: Icon(
            Icons.auto_awesome_rounded,
            color: colorScheme.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 11),
        Text(
          'AI Suggestions',
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildViewMoreButton(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    return Center(
      child: TextButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'More AI suggestions will be available '
                'when AI Tutor is connected.',
              ),
            ),
          );
        },
        icon: const Text('View more suggestions'),
        label: const Icon(
          Icons.arrow_forward_rounded,
          size: 17,
        ),
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
        ),
      ),
    );
  }
}

class _SuggestionItem extends StatefulWidget {
  final _SuggestionData suggestion;
  final int index;

  const _SuggestionItem({
    required this.suggestion,
    required this.index,
  });

  @override
  State<_SuggestionItem> createState() =>
      _SuggestionItemState();
}

class _SuggestionItemState extends State<_SuggestionItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
          _handleSuggestionTap(
            context,
            widget.suggestion,
          );
        },
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 180,
          ),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(13),
          transform: Matrix4.translationValues(
            _hovered ? 3 : 0,
            0,
            0,
          ),
          decoration: BoxDecoration(
            color: _hovered
                ? colorScheme.primary.withValues(
                    alpha: 0.07,
                  )
                : colorScheme.surface.withValues(
                    alpha: 0.18,
                  ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _hovered
                  ? colorScheme.primary.withValues(
                      alpha: 0.22,
                    )
                  : colorScheme.outline.withValues(
                      alpha: 0.07,
                    ),
            ),
          ),
          child: Row(
            children: [
              _buildSuggestionIcon(
                context,
                widget.index,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.suggestion.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.suggestion.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                          theme.textTheme.bodySmall?.copyWith(
                        color:
                            colorScheme.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              AnimatedContainer(
                duration: const Duration(
                  milliseconds: 160,
                ),
                transform: Matrix4.translationValues(
                  _hovered ? 3 : 0,
                  0,
                  0,
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: _hovered
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionIcon(
    BuildContext context,
    int index,
  ) {
    final colorScheme =
        Theme.of(context).colorScheme;

    final List<Color> colors = [
      colorScheme.primary,
      colorScheme.secondary,
      colorScheme.tertiary,
    ];

    final Color iconColor =
        colors[index % colors.length];

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            iconColor.withValues(alpha: 0.22),
            iconColor.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: iconColor.withValues(alpha: 0.18),
        ),
      ),
      child: Icon(
        widget.suggestion.icon,
        color: iconColor,
        size: 20,
      ),
    );
  }

  void _handleSuggestionTap(
    BuildContext context,
    _SuggestionData suggestion,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${suggestion.title} selected',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _SuggestionData {
  final String title;
  final String description;
  final IconData icon;

  const _SuggestionData({
    required this.title,
    required this.description,
    required this.icon,
  });
}