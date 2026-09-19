import 'package:flutter/material.dart';

import '../../../../core/widgets/main_app_shell.dart';

class StudyPlansPage extends StatefulWidget {
  const StudyPlansPage({super.key});

  @override
  State<StudyPlansPage> createState() => _StudyPlansPageState();
}

class _StudyPlansPageState extends State<StudyPlansPage> {
  final List<_StudyPlan> _plans = [
    _StudyPlan(
      title: 'IT Weekly Review',
      startDate: DateTime(2026, 6, 12),
      endDate: DateTime(2026, 6, 18),
      type: 'Weekly',
      subject: 'Data Structures',
    ),
  ];

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return MainAppShell(
      selectedRoute: '/study-plans',
      child: Container(
        color: const Color(0xFF030418),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool mobile = constraints.maxWidth < 700;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                mobile ? 18 : 40,
                mobile ? 22 : 28,
                mobile ? 18 : 40,
                40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, mobile),
                  SizedBox(height: mobile ? 26 : 30),
                  _buildPlans(context, mobile),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ==========================================================
  // HEADER
  // ==========================================================

  Widget _buildHeader(
    BuildContext context,
    bool mobile,
  ) {
    if (mobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Study Plans',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'Organize your study sessions.',
            style: TextStyle(
              color: Color(0xFFA3A6C5),
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _HeaderButton(
                  icon: Icons.auto_awesome_rounded,
                  label: 'AI Generate',
                  filled: false,
                  onPressed: () {
                    _showAiGenerateDialog(context);
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _HeaderButton(
                  icon: Icons.add_rounded,
                  label: 'New Plan',
                  filled: true,
                  onPressed: () {
                    _showNewPlanDialog(context);
                  },
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Study Plans',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.9,
                ),
              ),
              SizedBox(height: 7),
              Text(
                'Organize your study sessions.',
                style: TextStyle(
                  color: Color(0xFFA3A6C5),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        _HeaderButton(
          icon: Icons.auto_awesome_rounded,
          label: 'AI Generate',
          filled: false,
          onPressed: () {
            _showAiGenerateDialog(context);
          },
        ),
        const SizedBox(width: 14),
        _HeaderButton(
          icon: Icons.add_rounded,
          label: 'New Plan',
          filled: true,
          onPressed: () {
            _showNewPlanDialog(context);
          },
        ),
      ],
    );
  }

  // ==========================================================
  // PLANS
  // ==========================================================

  Widget _buildPlans(
    BuildContext context,
    bool mobile,
  ) {
    if (_plans.isEmpty) {
      return _EmptyPlans(
        onCreate: () {
          _showNewPlanDialog(context);
        },
      );
    }

    return Column(
      children: [
        for (final plan in _plans)
          _StudyPlanCard(
            plan: plan,
            onTap: () {
              _showPlanDetails(context, plan);
            },
          ),
      ],
    );
  }

  // ==========================================================
  // NEW PLAN DIALOG
  // ==========================================================

  void _showNewPlanDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    String selectedType = 'Revision';
    String selectedSubject = 'Math';

    DateTime? startDate;
    DateTime? endDate;

    showDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.78),
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (
            context,
            setDialogState,
          ) {
            return _PlanDialog(
              title: 'New Study Plan',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _DialogLabel('Title'),
                  const SizedBox(height: 8),

                  _DialogTextField(
                    controller: titleController,
                    icon: Icons.calendar_today_outlined,
                    hint: 'e.g. Finish Math Plan',
                  ),

                  const SizedBox(height: 18),

                  const _DialogLabel('Description'),
                  const SizedBox(height: 8),

                  _DialogTextField(
                    controller: descriptionController,
                    icon: Icons.description_outlined,
                    hint: "What's the focus of this plan?",
                    maxLines: 3,
                  ),

                  const SizedBox(height: 18),

                  LayoutBuilder(
                    builder: (
                      context,
                      constraints,
                    ) {
                      if (constraints.maxWidth < 420) {
                        return Column(
                          children: [
                            _DialogDropdown(
                              label: 'Type',
                              icon: Icons.menu_book_outlined,
                              value: selectedType,
                              items: const [
                                'Revision',
                                'Learning',
                                'Practice',
                                'Exam Preparation',
                              ],
                              onChanged: (value) {
                                setDialogState(() {
                                  selectedType = value;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            _DialogDropdown(
                              label: 'Subject (Optional)',
                              icon: Icons.menu_book_outlined,
                              value: selectedSubject,
                              items: const [
                                'Math',
                                'Data Structures',
                                'Web Development',
                                'Physics',
                              ],
                              onChanged: (value) {
                                setDialogState(() {
                                  selectedSubject = value;
                                });
                              },
                            ),
                          ],
                        );
                      }

                      return Row(
                        children: [
                          Expanded(
                            child: _DialogDropdown(
                              label: 'Type',
                              icon:
                                  Icons.menu_book_outlined,
                              value: selectedType,
                              items: const [
                                'Revision',
                                'Learning',
                                'Practice',
                                'Exam Preparation',
                              ],
                              onChanged: (value) {
                                setDialogState(() {
                                  selectedType = value;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: _DialogDropdown(
                              label: 'Subject (Optional)',
                              icon:
                                  Icons.menu_book_outlined,
                              value: selectedSubject,
                              items: const [
                                'Math',
                                'Data Structures',
                                'Web Development',
                                'Physics',
                              ],
                              onChanged: (value) {
                                setDialogState(() {
                                  selectedSubject = value;
                                });
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 18),

                  LayoutBuilder(
                    builder: (
                      context,
                      constraints,
                    ) {
                      if (constraints.maxWidth < 420) {
                        return Column(
                          children: [
                            _DateField(
                              label: 'Start Date',
                              date: startDate,
                              onTap: () async {
                                final date =
                                    await _pickDate(
                                  context,
                                  startDate,
                                );

                                if (date != null) {
                                  setDialogState(() {
                                    startDate = date;
                                  });
                                }
                              },
                            ),
                            const SizedBox(height: 16),
                            _DateField(
                              label: 'End Date',
                              date: endDate,
                              onTap: () async {
                                final date =
                                    await _pickDate(
                                  context,
                                  endDate,
                                );

                                if (date != null) {
                                  setDialogState(() {
                                    endDate = date;
                                  });
                                }
                              },
                            ),
                          ],
                        );
                      }

                      return Row(
                        children: [
                          Expanded(
                            child: _DateField(
                              label: 'Start Date',
                              date: startDate,
                              onTap: () async {
                                final date =
                                    await _pickDate(
                                  context,
                                  startDate,
                                );

                                if (date != null) {
                                  setDialogState(() {
                                    startDate = date;
                                  });
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: _DateField(
                              label: 'End Date',
                              date: endDate,
                              onTap: () async {
                                final date =
                                    await _pickDate(
                                  context,
                                  endDate,
                                );

                                if (date != null) {
                                  setDialogState(() {
                                    endDate = date;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.end,
                    children: [
                      _DialogButton(
                        label: 'Cancel',
                        filled: false,
                        onPressed: () {
                          Navigator.pop(dialogContext);
                        },
                      ),
                      const SizedBox(width: 12),
                      _DialogButton(
                        label: 'Create Plan',
                        filled: true,
                        onPressed: () {
                          final title =
                              titleController.text.trim();

                          if (title.isEmpty) {
                            _showError(
                              context,
                              'Please enter a plan title.',
                            );
                            return;
                          }

                          final now = DateTime.now();

                          final plan =
                              _StudyPlan(
                            title: title,
                            startDate:
                                startDate ??
                                    now,
                            endDate:
                                endDate ??
                                    now.add(
                                      const Duration(
                                        days: 7,
                                      ),
                                    ),
                            type: selectedType,
                            subject: selectedSubject,
                          );

                          setState(() {
                            _plans.insert(0, plan);
                          });

                          Navigator.pop(
                            dialogContext,
                          );

                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Study plan created successfully.',
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ==========================================================
  // AI GENERATE DIALOG
  // ==========================================================

  void _showAiGenerateDialog(BuildContext context) {
    String subject = 'Data Structures';
    String duration = 'Weekly';

    final hoursController = TextEditingController(
      text: '2',
    );

    final goalsController = TextEditingController();

    showDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.78),
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (
            context,
            setDialogState,
          ) {
            return _PlanDialog(
              title: 'AI Generate Study Plan',
              titleIcon: Icons.auto_awesome_rounded,
              subtitle:
                  "Tell the AI what you need — it'll create a plan with tasks automatically.",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _DialogLabel('Subject'),
                  const SizedBox(height: 8),

                  _DialogDropdown(
                    label: '',
                    icon: Icons.menu_book_outlined,
                    value: subject,
                    items: const [
                      'Data Structures',
                      'Calculus II',
                      'Web Development',
                      'Database Systems',
                    ],
                    onChanged: (value) {
                      setDialogState(() {
                        subject = value;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  LayoutBuilder(
                    builder: (
                      context,
                      constraints,
                    ) {
                      if (constraints.maxWidth < 420) {
                        return Column(
                          children: [
                            _DialogDropdown(
                              label: 'Plan Duration',
                              icon:
                                  Icons.calendar_month_outlined,
                              value: duration,
                              items: const [
                                'Weekly',
                                '2 Weeks',
                                'Monthly',
                              ],
                              onChanged: (value) {
                                setDialogState(() {
                                  duration = value;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            _DialogTextField(
                              controller: hoursController,
                              icon: Icons.schedule_rounded,
                              hint: 'Hours per day',
                              keyboardType:
                                  TextInputType.number,
                            ),
                          ],
                        );
                      }

                      return Row(
                        children: [
                          Expanded(
                            child: _DialogDropdown(
                              label: 'Plan Duration',
                              icon: Icons
                                  .calendar_month_outlined,
                              value: duration,
                              items: const [
                                'Weekly',
                                '2 Weeks',
                                'Monthly',
                              ],
                              onChanged: (value) {
                                setDialogState(() {
                                  duration = value;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: _DialogTextField(
                              controller: hoursController,
                              icon: Icons.schedule_rounded,
                              hint: 'Hours per day',
                              keyboardType:
                                  TextInputType.number,
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  const _DialogLabel(
                    'Goals & Key Topics',
                  ),
                  const SizedBox(height: 8),

                  _DialogTextField(
                    controller: goalsController,
                    icon: Icons.notes_rounded,
                    hint:
                        'e.g. Chapter 3: 6 service problems, examples, implementations.',
                    maxLines: 3,
                  ),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.end,
                    children: [
                      _DialogButton(
                        label: 'Cancel',
                        filled: false,
                        onPressed: () {
                          Navigator.pop(
                            dialogContext,
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      _DialogButton(
                        label: 'Generate Plan',
                        icon:
                            Icons.auto_awesome_rounded,
                        filled: true,
                        onPressed: () {
                          final hours =
                              double.tryParse(
                                    hoursController
                                        .text
                                        .trim(),
                                  ) ??
                                  2;

                          final now = DateTime.now();

                          final int days =
                              duration == 'Weekly'
                                  ? 7
                                  : duration == '2 Weeks'
                                      ? 14
                                      : 30;

                          final plan =
                              _StudyPlan(
                            title:
                                '$subject Study Plan',
                            startDate: now,
                            endDate:
                                now.add(
                              Duration(
                                days: days,
                              ),
                            ),
                            type: duration,
                            subject: subject,
                            hoursPerDay: hours,
                          );

                          setState(() {
                            _plans.insert(0, plan);
                          });

                          Navigator.pop(
                            dialogContext,
                          );

                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'AI study plan generated successfully.',
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ==========================================================
  // PLAN DETAILS
  // ==========================================================

  void _showPlanDetails(
    BuildContext context,
    _StudyPlan plan,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: const Color(0xFF080A29),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(
              color: Color(0xFF332A69),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(26),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Study Plan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(
                          dialogContext,
                        );
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  plan.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '${_formatDate(plan.startDate)} – ${_formatDate(plan.endDate)}',
                  style: const TextStyle(
                    color: Color(0xFFB2B5D1),
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${plan.subject} • ${plan.type}',
                  style: const TextStyle(
                    color: Color(0xFF8E5CFF),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================================
  // DATE PICKER
  // ==========================================================

  Future<DateTime?> _pickDate(
    BuildContext context,
    DateTime? current,
  ) {
    return showDatePicker(
      context: context,
      initialDate:
          current ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF7136F4),
              onPrimary: Colors.white,
              surface: Color(0xFF0A0D2C),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
  }

  // ==========================================================
  // ERROR
  // ==========================================================

  void _showError(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // ==========================================================
  // DATE FORMAT
  // ==========================================================

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

    return '${months[date.month - 1]} ${date.day}';
  }
}

// ============================================================================
// HEADER BUTTON
// ============================================================================

class _HeaderButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool filled;
  final VoidCallback onPressed;

  const _HeaderButton({
    required this.icon,
    required this.label,
    required this.filled,
    required this.onPressed,
  });

  @override
  State<_HeaderButton> createState() =>
      _HeaderButtonState();
}

class _HeaderButtonState
    extends State<_HeaderButton> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() {
          hovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          hovered = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 150,
        ),
        decoration: BoxDecoration(
          gradient: widget.filled
              ? const LinearGradient(
                  colors: [
                    Color(0xFF6720E8),
                    Color(0xFF8718EA),
                  ],
                )
              : null,
          color: widget.filled
              ? null
              : const Color(0xFF05071B),
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: widget.filled
                ? hovered
                    ? const Color(0xFFB276FF)
                    : const Color(0xFF7025F0)
                : const Color(0xFF292C52),
          ),
          boxShadow: widget.filled && hovered
              ? [
                  BoxShadow(
                    color: const Color(
                      0xFF7B2CF5,
                    ).withValues(alpha: 0.25),
                    blurRadius: 18,
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(9),
            onTap: widget.onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 13,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    widget.icon,
                    size: 19,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 9),
                  Text(
                    widget.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// STUDY PLAN CARD
// ============================================================================

class _StudyPlanCard extends StatefulWidget {
  final _StudyPlan plan;
  final VoidCallback onTap;

  const _StudyPlanCard({
    required this.plan,
    required this.onTap,
  });

  @override
  State<_StudyPlanCard> createState() =>
      _StudyPlanCardState();
}

class _StudyPlanCardState
    extends State<_StudyPlanCard> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    final plan = widget.plan;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() {
          hovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          hovered = false;
        });
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 180,
          ),
          width: double.infinity,
          constraints: const BoxConstraints(
            maxWidth: 790,
            minHeight: 210,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF080A29),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: hovered
                  ? const Color(0xFF753CFF)
                  : const Color(0xFF242754),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(
                  0xFF6C28F3,
                ).withValues(
                  alpha: hovered ? 0.13 : 0.035,
                ),
                blurRadius: hovered ? 28 : 18,
              ),
            ],
          ),
          child: Stack(
            children: [
              // ============================================================
              // PURPLE LEFT BORDER
              // ============================================================

              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 4,
                  decoration: const BoxDecoration(
                    color: Color(0xFF7933F5),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(14),
                      bottomLeft:
                          Radius.circular(14),
                    ),
                  ),
                ),
              ),

              // ============================================================
              // DECORATIVE GLOW
              // ============================================================

              Positioned(
                right: 20,
                top: 12,
                child: IgnorePointer(
                  child: SizedBox(
                    width: 190,
                    height: 150,
                    child: CustomPaint(
                      painter:
                          _PlanDecorationPainter(),
                    ),
                  ),
                ),
              ),

              // ============================================================
              // CONTENT
              // ============================================================

              Padding(
                padding: const EdgeInsets.fromLTRB(
                  34,
                  25,
                  30,
                  24,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(
                          0xFF5421BD,
                        ),
                        borderRadius:
                            BorderRadius.circular(7),
                      ),
                      child: const Text(
                        'CURRENT PLAN',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      plan.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          color: Color(0xFFB2B5D2),
                          size: 19,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${_formatDate(plan.startDate)} – ${_formatDate(plan.endDate)}',
                          style: const TextStyle(
                            color: Color(0xFFB8BBD5),
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),

                    if (plan.hoursPerDay != null) ...[
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(
                            Icons.schedule_rounded,
                            color: Color(0xFF8E5CFF),
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${plan.hoursPerDay!.toStringAsFixed(0)} hours/day',
                            style: const TextStyle(
                              color: Color(0xFF9E8BFF),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // ============================================================
              // ARROW
              // ============================================================

              Positioned(
                right: 20,
                bottom: 22,
                child: AnimatedContainer(
                  duration: const Duration(
                    milliseconds: 150,
                  ),
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: hovered
                        ? const Color(0xFF7136F4)
                            .withValues(alpha: 0.16)
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Color(0xFF9C61FF),
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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

    return '${months[date.month - 1]} ${date.day}';
  }
}

// ============================================================================
// DECORATION PAINTER
// ============================================================================

class _PlanDecorationPainter
    extends CustomPainter {
  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = const Color(0xFF7036F5)
          .withValues(alpha: 0.65);

    final center = Offset(
      size.width * 0.63,
      size.height * 0.55,
    );

    canvas.drawCircle(
      center,
      46,
      paint,
    );

    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(
          center.dx,
          center.dy - 7,
        ),
        width: 42,
        height: 44,
      ),
      paint,
    );

    canvas.drawCircle(
      Offset(
        center.dx + 12,
        center.dy + 20,
      ),
      14,
      paint,
    );

    final checkPaint = Paint()
      ..color = const Color(0xFF7A3CFF)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(
        center.dx - 13,
        center.dy - 5,
      )
      ..lineTo(
        center.dx - 7,
        center.dy + 1,
      )
      ..lineTo(
        center.dx + 4,
        center.dy - 10,
      );

    canvas.drawPath(
      path,
      checkPaint,
    );

    _drawSparkle(
      canvas,
      Offset(
        size.width * 0.85,
        size.height * 0.12,
      ),
      7,
    );

    _drawSparkle(
      canvas,
      Offset(
        size.width * 0.20,
        size.height * 0.22,
      ),
      5,
    );
  }

  void _drawSparkle(
    Canvas canvas,
    Offset center,
    double radius,
  ) {
    final paint = Paint()
      ..color = const Color(0xFF7D43FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path()
      ..moveTo(
        center.dx,
        center.dy - radius,
      )
      ..lineTo(
        center.dx,
        center.dy + radius,
      )
      ..moveTo(
        center.dx - radius,
        center.dy,
      )
      ..lineTo(
        center.dx + radius,
        center.dy,
      );

    canvas.drawPath(
      path,
      paint,
    );
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}

// ============================================================================
// EMPTY PLANS
// ============================================================================

class _EmptyPlans extends StatelessWidget {
  final VoidCallback onCreate;

  const _EmptyPlans({
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(
        maxWidth: 790,
      ),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: const Color(0xFF080A29),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF242754),
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.calendar_month_outlined,
            color: Color(0xFF7A3CFF),
            size: 45,
          ),
          const SizedBox(height: 14),
          const Text(
            'No Study Plans Yet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Create your first study plan to organize your learning.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF9EA2C6),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: onCreate,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF6817EA),
            ),
            child: const Text(
              'Create Plan',
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// PLAN DIALOG
// ============================================================================

class _PlanDialog extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? titleIcon;
  final Widget child;

  const _PlanDialog({
    required this.title,
    required this.child,
    this.subtitle,
    this.titleIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 24,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 560,
          maxHeight: 760,
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            34,
            27,
            34,
            30,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF080A29),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF5935A7),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.55,
                ),
                blurRadius: 45,
              ),
              BoxShadow(
                color: const Color(0xFF6526D8)
                    .withValues(alpha: 0.08),
                blurRadius: 60,
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (titleIcon != null) ...[
                      Icon(
                        titleIcon,
                        color: const Color(
                          0xFF9C63FF,
                        ),
                        size: 23,
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),

                if (subtitle != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      color: Color(0xFFB1B4CF),
                      fontSize: 14,
                      height: 1.45,
                    ),
                  ),
                ],

                const SizedBox(height: 23),

                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// DIALOG LABEL
// ============================================================================

class _DialogLabel extends StatelessWidget {
  final String text;

  const _DialogLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

// ============================================================================
// DIALOG TEXT FIELD
// ============================================================================

class _DialogTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final String hint;
  final int maxLines;
  final TextInputType? keyboardType;

  const _DialogTextField({
    required this.controller,
    required this.icon,
    required this.hint,
    this.maxLines = 1,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
      cursorColor: const Color(0xFF8B5CF6),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFF8589A9),
          fontSize: 13,
        ),
        prefixIcon: Icon(
          icon,
          color: const Color(0xFF8D92B7),
          size: 20,
        ),
        filled: true,
        fillColor: const Color(0xFF070920),
        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 13,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFF30345A),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFF793DFF),
            width: 1.3,
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// DROPDOWN
// ============================================================================

class _DialogDropdown extends StatelessWidget {
  final String label;
  final IconData icon;
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  const _DialogDropdown({
    required this.label,
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          _DialogLabel(label),
          const SizedBox(height: 8),
        ],
        DropdownButtonFormField<String>(
          initialValue: value,
          dropdownColor: const Color(0xFF10122F),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFFB5B8D2),
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: const Color(0xFF8B5CF6),
              size: 20,
            ),
            filled: true,
            fillColor: const Color(0xFF070920),
            contentPadding:
                const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 2,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF30345A),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF793DFF),
                width: 1.2,
              ),
            ),
          ),
          items: [
            for (final item in items)
              DropdownMenuItem(
                value: item,
                child: Text(item),
              ),
          ],
          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
        ),
      ],
    );
  }
}

// ============================================================================
// DATE FIELD
// ============================================================================

class _DateField extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;

  const _DateField({
    required this.label,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        _DialogLabel(label),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF070920),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF30345A),
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                const Icon(
                  Icons.calendar_month_outlined,
                  color: Color(0xFF8B5CF6),
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    date == null
                        ? 'mm/dd/yyyy'
                        : _formatDate(date!),
                    style: TextStyle(
                      color: date == null
                          ? const Color(0xFF8589A9)
                          : Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ),
                const Icon(
                  Icons.calendar_today_outlined,
                  color: Color(0xFFB1B4CE),
                  size: 18,
                ),
                const SizedBox(width: 12),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final month =
        date.month.toString().padLeft(2, '0');
    final day =
        date.day.toString().padLeft(2, '0');

    return '$month/$day/${date.year}';
  }
}

// ============================================================================
// DIALOG BUTTON
// ============================================================================

class _DialogButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool filled;
  final VoidCallback onPressed;

  const _DialogButton({
    required this.label,
    required this.filled,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    if (filled) {
      return FilledButton.icon(
        onPressed: onPressed,
        icon: icon == null
            ? const SizedBox.shrink()
            : Icon(
                icon,
                size: 18,
              ),
        label: Text(label),
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF6817EA),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(
          color: Color(0xFF464A6A),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 13,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(label),
    );
  }
}

// ============================================================================
// DATA MODEL
// ============================================================================

class _StudyPlan {
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final String type;
  final String subject;
  final double? hoursPerDay;

  const _StudyPlan({
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.type,
    required this.subject,
    this.hoursPerDay,
  });
}