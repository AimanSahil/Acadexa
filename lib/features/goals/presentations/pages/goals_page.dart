import 'package:flutter/material.dart';

import '../../../../core/widgets/main_app_shell.dart';

class GoalsPage extends StatefulWidget {
  const GoalsPage({super.key});

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  final List<_GoalData> _goals = [
    _GoalData(
      title: 'Master Data Structures',
      description: 'Complete core data structures and algorithms.',
      progress: 0.65,
      completedTasks: 13,
      totalTasks: 20,
      deadline: DateTime(2026, 9, 30),
      priority: 'High',
      colorType: 0,
    ),
    _GoalData(
      title: 'Improve Calculus Skills',
      description: 'Strengthen calculus concepts and problem solving.',
      progress: 0.40,
      completedTasks: 8,
      totalTasks: 20,
      deadline: DateTime(2026, 10, 10),
      priority: 'Medium',
      colorType: 1,
    ),
    _GoalData(
      title: 'Build React Portfolio',
      description: 'Create and complete a professional portfolio.',
      progress: 0.25,
      completedTasks: 3,
      totalTasks: 12,
      deadline: DateTime(2026, 10, 25),
      priority: 'Low',
      colorType: 2,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MainAppShell(
      selectedRoute: '/goals',
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isMobile = constraints.maxWidth < 700;
            final bool isTablet = constraints.maxWidth < 1100;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: isMobile
                    ? 16
                    : isTablet
                        ? 22
                        : 30,
                vertical: isMobile ? 18 : 26,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, isMobile),
                  SizedBox(height: isMobile ? 20 : 26),
                  _buildOverview(context, isMobile),
                  SizedBox(height: isMobile ? 24 : 30),
                  _buildGoalsHeader(context, isMobile),
                  const SizedBox(height: 16),
                  _buildGoalsGrid(context, isMobile, isTablet),
                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Goals',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Set goals, track progress, and stay focused.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        FilledButton.icon(
          onPressed: () => _showCreateGoalDialog(context),
          icon: const Icon(Icons.add_rounded, size: 19),
          label: Text(isMobile ? 'Create' : 'Create New Goal'),
          style: FilledButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 12 : 18,
              vertical: 13,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOverview(BuildContext context, bool isMobile) {
    final int activeGoals = _goals.length;
    final int completedGoals =
        _goals.where((goal) => goal.progress >= 1.0).length;

    final double overallProgress = _goals.isEmpty
        ? 0
        : _goals.fold<double>(
              0,
              (sum, goal) => sum + goal.progress,
            ) /
            _goals.length;

    final cards = [
      _OverviewData(
        title: 'Active Goals',
        value: '$activeGoals',
        subtitle: 'Currently tracking',
        icon: Icons.flag_rounded,
      ),
      _OverviewData(
        title: 'Completed',
        value: '$completedGoals',
        subtitle: 'Goals completed',
        icon: Icons.check_circle_rounded,
      ),
      _OverviewData(
        title: 'Overall Progress',
        value: '${(overallProgress * 100).round()}%',
        subtitle: 'Across all goals',
        icon: Icons.trending_up_rounded,
      ),
    ];

    if (isMobile) {
      return Column(
        children: [
          for (int i = 0; i < cards.length; i++) ...[
            _buildOverviewCard(context, cards[i]),
            if (i != cards.length - 1) const SizedBox(height: 12),
          ],
        ],
      );
    }

    return Row(
      children: [
        for (int i = 0; i < cards.length; i++) ...[
          Expanded(
            child: _buildOverviewCard(context, cards[i]),
          ),
          if (i != cards.length - 1) const SizedBox(width: 14),
        ],
      ],
    );
  }

  Widget _buildOverviewCard(
    BuildContext context,
    _OverviewData data,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.28,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              data.icon,
              color: colorScheme.primary,
              size: 23,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  data.value,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data.subtitle,
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
        ],
      ),
    );
  }

  Widget _buildGoalsHeader(
    BuildContext context,
    bool isMobile,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            'Your Goals',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Text(
          '${_goals.length} goals',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildGoalsGrid(
    BuildContext context,
    bool isMobile,
    bool isTablet,
  ) {
    if (_goals.isEmpty) {
      return _buildEmptyState(context);
    }

    if (isMobile) {
      return Column(
        children: [
          for (int i = 0; i < _goals.length; i++) ...[
            _GoalCard(
              goal: _goals[i],
              onDelete: () => _deleteGoal(i),
              onEdit: () => _showEditGoalDialog(context, i),
              onProgressChanged: (value) {
                setState(() {
                  _goals[i].progress = value;
                  _goals[i].completedTasks =
                      (_goals[i].totalTasks * value).round();
                });
              },
            ),
            if (i != _goals.length - 1)
              const SizedBox(height: 14),
          ],
        ],
      );
    }

    final int columns = isTablet ? 2 : 3;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _goals.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: isTablet ? 1.28 : 1.15,
      ),
      itemBuilder: (context, index) {
        return _GoalCard(
          goal: _goals[index],
          onDelete: () => _deleteGoal(index),
          onEdit: () => _showEditGoalDialog(context, index),
          onProgressChanged: (value) {
            setState(() {
              _goals[index].progress = value;
              _goals[index].completedTasks =
                  (_goals[index].totalTasks * value).round();
            });
          },
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 55,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.22,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.flag_outlined,
            size: 48,
            color: colorScheme.primary,
          ),
          const SizedBox(height: 14),
          Text(
            'No goals yet',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Create your first goal and start tracking your progress.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: () => _showCreateGoalDialog(context),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Create Goal'),
          ),
        ],
      ),
    );
  }

  void _deleteGoal(int index) {
    final String title = _goals[index].title;

    setState(() {
      _goals.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _goals.insert(
                index,
                _GoalData(
                  title: title,
                  description: 'Goal restored.',
                  progress: 0,
                  completedTasks: 0,
                  totalTasks: 20,
                  deadline: DateTime.now().add(
                    const Duration(days: 30),
                  ),
                  priority: 'Medium',
                  colorType: 0,
                ),
              );
            });
          },
        ),
      ),
    );
  }

  void _showCreateGoalDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    DateTime selectedDate = DateTime.now().add(
      const Duration(days: 30),
    );

    String selectedPriority = 'Medium';

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Create New Goal'),
              content: SizedBox(
                width: 450,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: titleController,
                        autofocus: true,
                        decoration: const InputDecoration(
                          labelText: 'Goal title',
                          hintText: 'e.g. Master Data Structures',
                          prefixIcon: Icon(
                            Icons.flag_outlined,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: descriptionController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          hintText: 'What do you want to achieve?',
                          prefixIcon: Icon(
                            Icons.description_outlined,
                          ),
                          alignLabelWithHint: true,
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        initialValue: selectedPriority,
                        decoration: const InputDecoration(
                          labelText: 'Priority',
                          prefixIcon: Icon(
                            Icons.priority_high_rounded,
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'High',
                            child: Text('High'),
                          ),
                          DropdownMenuItem(
                            value: 'Medium',
                            child: Text('Medium'),
                          ),
                          DropdownMenuItem(
                            value: 'Low',
                            child: Text('Low'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setDialogState(() {
                              selectedPriority = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2035),
                            initialDate: selectedDate,
                          );

                          if (picked != null) {
                            setDialogState(() {
                              selectedDate = picked;
                            });
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Deadline',
                            prefixIcon: Icon(
                              Icons.calendar_today_rounded,
                            ),
                          ),
                          child: Text(
                            _formatDate(selectedDate),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    final title = titleController.text.trim();

                    if (title.isEmpty) {
                      return;
                    }

                    setState(() {
                      _goals.add(
                        _GoalData(
                          title: title,
                          description:
                              descriptionController.text.trim().isEmpty
                                  ? 'New academic goal.'
                                  : descriptionController.text.trim(),
                          progress: 0,
                          completedTasks: 0,
                          totalTasks: 10,
                          deadline: selectedDate,
                          priority: selectedPriority,
                          colorType: _goals.length % 3,
                        ),
                      );
                    });

                    Navigator.of(dialogContext).pop();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Goal created successfully'),
                      ),
                    );
                  },
                  child: const Text('Create Goal'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditGoalDialog(
    BuildContext context,
    int index,
  ) {
    final goal = _goals[index];

    final titleController = TextEditingController(
      text: goal.title,
    );

    final descriptionController = TextEditingController(
      text: goal.description,
    );

    String selectedPriority = goal.priority;

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Edit Goal'),
              content: SizedBox(
                width: 450,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Goal title',
                        prefixIcon: Icon(
                          Icons.flag_outlined,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        prefixIcon: Icon(
                          Icons.description_outlined,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: selectedPriority,
                      decoration: const InputDecoration(
                        labelText: 'Priority',
                        prefixIcon: Icon(
                          Icons.priority_high_rounded,
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'High',
                          child: Text('High'),
                        ),
                        DropdownMenuItem(
                          value: 'Medium',
                          child: Text('Medium'),
                        ),
                        DropdownMenuItem(
                          value: 'Low',
                          child: Text('Low'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            selectedPriority = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    final title = titleController.text.trim();

                    if (title.isEmpty) {
                      return;
                    }

                    setState(() {
                      goal.title = title;
                      goal.description =
                          descriptionController.text.trim().isEmpty
                              ? 'Academic goal.'
                              : descriptionController.text.trim();
                      goal.priority = selectedPriority;
                    });

                    Navigator.of(dialogContext).pop();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Goal updated successfully'),
                      ),
                    );
                  },
                  child: const Text('Save Changes'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class _GoalCard extends StatefulWidget {
  final _GoalData goal;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final ValueChanged<double> onProgressChanged;

  const _GoalCard({
    required this.goal,
    required this.onDelete,
    required this.onEdit,
    required this.onProgressChanged,
  });

  @override
  State<_GoalCard> createState() => _GoalCardState();
}

class _GoalCardState extends State<_GoalCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final Color accent = _getAccentColor(colorScheme);

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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(
            alpha: _hovered ? 0.40 : 0.26,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _hovered
                ? accent.withValues(alpha: 0.28)
                : colorScheme.outline.withValues(alpha: 0.11),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: _hovered ? 0.16 : 0.08,
              ),
              blurRadius: _hovered ? 28 : 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(
                    Icons.flag_rounded,
                    color: accent,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.goal.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.goal.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  tooltip: 'Goal options',
                  onSelected: (value) {
                    if (value == 'edit') {
                      widget.onEdit();
                    }

                    if (value == 'delete') {
                      widget.onDelete();
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit goal'),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete goal'),
                    ),
                  ],
                  icon: Icon(
                    Icons.more_horiz_rounded,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Text(
                  'Progress',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  '${(widget.goal.progress * 100).round()}%',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: accent,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: widget.goal.progress,
                minHeight: 7,
                backgroundColor: colorScheme.onSurface.withValues(
                  alpha: 0.08,
                ),
                valueColor: AlwaysStoppedAnimation<Color>(accent),
              ),
            ),
            const SizedBox(height: 9),
            Row(
              children: [
                Icon(
                  Icons.check_circle_outline_rounded,
                  size: 15,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 5),
                Text(
                  '${widget.goal.completedTasks}/${widget.goal.totalTasks} tasks',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const Spacer(),
            const SizedBox(height: 15),
            Row(
              children: [
                _buildInfoChip(
                  context,
                  Icons.calendar_today_rounded,
                  _formatCardDate(widget.goal.deadline),
                ),
                const SizedBox(width: 8),
                _buildPriorityChip(
                  context,
                  widget.goal.priority,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(
    BuildContext context,
    IconData icon,
    String text,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: colorScheme.onSurface.withValues(alpha: 0.045),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 13,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityChip(
    BuildContext context,
    String priority,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    Color color;

    switch (priority) {
      case 'High':
        color = colorScheme.error;
        break;
      case 'Low':
        color = colorScheme.tertiary;
        break;
      default:
        color = colorScheme.primary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        priority,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Color _getAccentColor(ColorScheme colorScheme) {
    switch (widget.goal.colorType) {
      case 1:
        return colorScheme.tertiary;
      case 2:
        return colorScheme.secondary;
      default:
        return colorScheme.primary;
    }
  }

  String _formatCardDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${months[date.month - 1]} ${date.day}';
  }
}

class _GoalData {
  String title;
  String description;
  double progress;
  int completedTasks;
  int totalTasks;
  DateTime deadline;
  String priority;
  int colorType;

  _GoalData({
    required this.title,
    required this.description,
    required this.progress,
    required this.completedTasks,
    required this.totalTasks,
    required this.deadline,
    required this.priority,
    required this.colorType,
  });
}

class _OverviewData {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;

  const _OverviewData({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
  });
}