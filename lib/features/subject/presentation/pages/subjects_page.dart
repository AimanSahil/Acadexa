import 'package:flutter/material.dart';

import '../../../../core/widgets/main_app_shell.dart';

class SubjectsPage extends StatefulWidget {
  const SubjectsPage({super.key});

  @override
  State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  final List<_SubjectData> _subjects = [
    _SubjectData(
      title: 'Data Structures',
      description: 'Learn trees, arrays, algorithms and more.',
      difficulty: 'Hard',
      priority: 'High Priority',
      color: const Color(0xFF6735F5),
      icon: Icons.code_rounded,
    ),
    _SubjectData(
      title: 'Calculus II',
      description: 'Multivariable calculus and series.',
      difficulty: 'Hard',
      priority: 'High Priority',
      color: const Color(0xFFE52DB8),
      icon: Icons.functions_rounded,
    ),
    _SubjectData(
      title: 'Web Development',
      description: 'Full-stack development with Node.js',
      difficulty: 'Medium',
      priority: 'Medium Priority',
      color: const Color(0xFF00D99A),
      icon: Icons.laptop_mac_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MainAppShell(
      selectedRoute: '/subjects',
      child: Container(
        color: const Color(0xFF030418),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isMobile = constraints.maxWidth < 700;
            final bool isTablet = constraints.maxWidth < 1100;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                isMobile ? 18 : 44,
                isMobile ? 22 : 38,
                isMobile ? 18 : 44,
                40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(
                    context,
                    isMobile,
                  ),
                  SizedBox(
                    height: isMobile ? 24 : 28,
                  ),
                  _buildSubjectGrid(
                    context,
                    isMobile,
                    isTablet,
                  ),
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
    bool isMobile,
  ) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Subjects',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.7,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Manage your academic subjects and courses.',
            style: TextStyle(
              color: Color(0xFF9EA2C6),
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: () => _showAddDialog(context),
            icon: const Icon(
              Icons.add_rounded,
              size: 19,
            ),
            label: const Text('Add Subject'),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF6817EA),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 13,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
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
                'Subjects',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.9,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Manage your academic subjects and courses.',
                style: TextStyle(
                  color: Color(0xFF9EA2C6),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        FilledButton.icon(
          onPressed: () => _showAddDialog(context),
          icon: const Icon(
            Icons.add_rounded,
            size: 20,
          ),
          label: const Text('Add Subject'),
          style: ButtonStyle(
            backgroundColor: const WidgetStatePropertyAll(
              Color(0xFF6817EA),
            ),
            foregroundColor: const WidgetStatePropertyAll(
              Colors.white,
            ),
            padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 14,
              ),
            ),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(9),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
  // ==========================================================
  // SUBJECT GRID
  // ==========================================================
  Widget _buildSubjectGrid(
    BuildContext context,
    bool isMobile,
    bool isTablet,
  ) {
    if (isMobile) {
      return Column(
        children: [
          for (int i = 0; i < _subjects.length; i++) ...[
            _SubjectCard(
              subject: _subjects[i],
              onEdit: () => _showEditDialog(
                context,
                i,
              ),
              onDelete: () => _deleteSubject(i),
            ),
            if (i < _subjects.length - 1)
              const SizedBox(height: 16),
          ],
        ],
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _subjects.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isTablet ? 2 : 3,
        crossAxisSpacing: isTablet ? 20 : 28,
        mainAxisSpacing: 20,
        childAspectRatio: isTablet ? 1.55 : 1.42,
      ),
      itemBuilder: (context, index) {
        return _SubjectCard(
          subject: _subjects[index],
          onEdit: () => _showEditDialog(
            context,
            index,
          ),
          onDelete: () => _deleteSubject(index),
        );
      },
    );
  }
  // ==========================================================
  // ADD SUBJECT
  // ==========================================================
  void _showAddDialog(BuildContext context) {
    _showSubjectDialog(
      context: context,
      subject: null,
    );
  }
  // ==========================================================
  // EDIT SUBJECT
  // ==========================================================
  void _showEditDialog(
    BuildContext context,
    int index,
  ) {
    _showSubjectDialog(
      context: context,
      subject: _subjects[index],
      index: index,
    );
  }
  // ==========================================================
  // SUBJECT DIALOG
  // ==========================================================
  void _showSubjectDialog({
    required BuildContext context,
    required _SubjectData? subject,
    int? index,
  }) {
    final titleController = TextEditingController(
      text: subject?.title ?? '',
    );

    final descriptionController = TextEditingController(
      text: subject?.description ?? '',
    );

    String difficulty = subject?.difficulty ?? 'Easy';

    String priority =
        subject?.priority.replaceAll(' Priority', '') ??
            'Medium';

    Color selectedColor =
        subject?.color ?? const Color(0xFF6735F5);

    showDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(
        alpha: 0.76,
      ),
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (
            context,
            setDialogState,
          ) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 24,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 550,
                  maxHeight: 650,
                ),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(
                    28,
                    24,
                    28,
                    28,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF080A29),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF6338D8),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: 0.5,
                        ),
                        blurRadius: 45,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        // ==================================================
                        // DIALOG HEADER
                        // ==================================================
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                subject == null
                                    ? 'Add New Subject'
                                    : 'Edit Subject',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 21,
                                  fontWeight:
                                      FontWeight.w700,
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
                                color: Color(0xFFD8DAED),
                                size: 22,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),
                        // ==================================================
                        // TITLE
                        // ==================================================
                        const _Label('Title'),
                        const SizedBox(height: 7),

                        _TextField(
                          controller: titleController,
                          hint: 'e.g. Data Structures',
                          icon:
                              Icons.menu_book_outlined,
                        ),

                        const SizedBox(height: 16),
                        // ==================================================
                        // DESCRIPTION
                        // ==================================================
                        const _Label('Description'),
                        const SizedBox(height: 7),

                        _TextField(
                          controller:
                              descriptionController,
                          hint:
                              'Course details, topics covered...',
                          icon:
                              Icons.description_outlined,
                          maxLines: 3,
                        ),

                        const SizedBox(height: 18),
                        // ==================================================
                        // COLOR
                        // ==================================================
                        const _Label('Color'),
                        const SizedBox(height: 9),

                        Wrap(
                          spacing: 12,
                          runSpacing: 9,
                          children: [
                            for (final color
                                in _subjectColors)
                              _ColorButton(
                                color: color,
                                selected:
                                    selectedColor ==
                                        color,
                                onTap: () {
                                  setDialogState(() {
                                    selectedColor =
                                        color;
                                  });
                                },
                              ),
                          ],
                        ),

                        const SizedBox(height: 20),
                        // ==================================================
                        // DIFFICULTY + PRIORITY
                        // ==================================================
                        LayoutBuilder(
                          builder: (
                            context,
                            constraints,
                          ) {
                            if (constraints.maxWidth <
                                400) {
                              return Column(
                                children: [
                                  _Dropdown(
                                    label: 'Difficulty',
                                    icon: Icons
                                        .bar_chart_rounded,
                                    value: difficulty,
                                    items: const [
                                      'Easy',
                                      'Medium',
                                      'Hard',
                                    ],
                                    onChanged: (value) {
                                      setDialogState(() {
                                        difficulty =
                                            value;
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    height: 14,
                                  ),
                                  _Dropdown(
                                    label: 'Priority',
                                    icon: Icons
                                        .flag_outlined,
                                    value: priority,
                                    items: const [
                                      'Low',
                                      'Medium',
                                      'High',
                                    ],
                                    onChanged: (value) {
                                      setDialogState(() {
                                        priority = value;
                                      });
                                    },
                                  ),
                                ],
                              );
                            }

                            return Row(
                              children: [
                                Expanded(
                                  child: _Dropdown(
                                    label: 'Difficulty',
                                    icon: Icons
                                        .bar_chart_rounded,
                                    value: difficulty,
                                    items: const [
                                      'Easy',
                                      'Medium',
                                      'Hard',
                                    ],
                                    onChanged: (value) {
                                      setDialogState(() {
                                        difficulty =
                                            value;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                  child: _Dropdown(
                                    label: 'Priority',
                                    icon: Icons
                                        .flag_outlined,
                                    value: priority,
                                    items: const [
                                      'Low',
                                      'Medium',
                                      'High',
                                    ],
                                    onChanged: (value) {
                                      setDialogState(() {
                                        priority = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),

                        const SizedBox(height: 22),
                        // ==================================================
                        // ADD / SAVE BUTTON
                        // ==================================================
                        Align(
                          alignment:
                              Alignment.centerRight,
                          child: FilledButton(
                            onPressed: () {
                              final title =
                                  titleController.text
                                      .trim();

                              if (title.isEmpty) {
                                return;
                              }

                              final data = _SubjectData(
                                title: title,
                                description:
                                    descriptionController
                                            .text
                                            .trim()
                                            .isEmpty
                                        ? 'Academic subject'
                                        : descriptionController
                                            .text
                                            .trim(),
                                difficulty: difficulty,
                                priority:
                                    '$priority Priority',
                                color: selectedColor,
                                icon: _iconForColor(
                                  selectedColor,
                                ),
                              );

                              setState(() {
                                if (index == null) {
                                  _subjects.add(data);
                                } else {
                                  _subjects[index] =
                                      data;
                                }
                              });

                              Navigator.pop(
                                dialogContext,
                              );

                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    index == null
                                        ? 'Subject added successfully'
                                        : 'Subject updated successfully',
                                  ),
                                ),
                              );
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFF6817EA),
                              foregroundColor:
                                  Colors.white,
                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                horizontal: 24,
                                vertical: 13,
                              ),
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                  9,
                                ),
                              ),
                            ),
                            child: Text(
                              index == null
                                  ? 'Add Subject'
                                  : 'Save Changes',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
  // ==========================================================
  // DELETE
  // ==========================================================
  void _deleteSubject(int index) {
    final deleted = _subjects[index];

    setState(() {
      _subjects.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${deleted.title} deleted',
        ),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _subjects.insert(
                index,
                deleted,
              );
            });
          },
        ),
      ),
    );
  }
  // ==========================================================
  // ICON BY COLOR
  // ==========================================================
  IconData _iconForColor(Color color) {
    if (color == const Color(0xFFE52DB8)) {
      return Icons.functions_rounded;
    }

    if (color == const Color(0xFF00D99A)) {
      return Icons.laptop_mac_rounded;
    }

    if (color == const Color(0xFFFF7518)) {
      return Icons.science_rounded;
    }

    if (color == const Color(0xFFEF4056)) {
      return Icons.biotech_rounded;
    }

    if (color == const Color(0xFFF1B51C)) {
      return Icons.calculate_rounded;
    }

    return Icons.code_rounded;
  }
}

// ============================================================================
// SUBJECT CARD
// ============================================================================

class _SubjectCard extends StatefulWidget {
  final _SubjectData subject;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _SubjectCard({
    required this.subject,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_SubjectCard> createState() =>
      _SubjectCardState();
}

class _SubjectCardState
    extends State<_SubjectCard> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    final subject = widget.subject;

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
          milliseconds: 180,
        ),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFF080A29),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: hovered
                ? subject.color.withValues(
                    alpha: 0.55,
                  )
                : const Color(0xFF252758),
          ),
          boxShadow: [
            BoxShadow(
              color: subject.color.withValues(
                alpha: hovered ? 0.13 : 0.035,
              ),
              blurRadius: hovered ? 25 : 12,
            ),
          ],
        ),
        child: Stack(
          children: [
            // ============================================================
            // TOP COLOR LINE
            // ============================================================

            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: Container(
                height: 3,
                color: subject.color,
              ),
            ),

            // ============================================================
            // CARD CONTENT
            // ============================================================

            Padding(
              padding: const EdgeInsets.fromLTRB(
                28,
                26,
                20,
                20,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  // ========================================================
                  // ICON + MENU
                  // ========================================================

                  Row(
                    children: [
                      _SubjectIcon(
                        icon: subject.icon,
                        color: subject.color,
                      ),
                      const Spacer(),
                      PopupMenuButton<String>(
                        tooltip: 'Subject options',
                        color: const Color(0xFF111333),
                        onSelected: (value) {
                          if (value == 'edit') {
                            widget.onEdit();
                          }

                          if (value == 'delete') {
                            widget.onDelete();
                          }
                        },
                        itemBuilder: (context) {
                          return const [
                            PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.edit_rounded,
                                    size: 18,
                                  ),
                                  SizedBox(width: 10),
                                  Text('Edit'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons
                                        .delete_outline_rounded,
                                    size: 18,
                                  ),
                                  SizedBox(width: 10),
                                  Text('Delete'),
                                ],
                              ),
                            ),
                          ];
                        },
                        icon: const Icon(
                          Icons.more_vert_rounded,
                          color: Color(0xFF9EA2C6),
                          size: 22,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // ========================================================
                  // TITLE
                  // ========================================================

                  Text(
                    subject.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.4,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ========================================================
                  // DESCRIPTION
                  // ========================================================

                  Expanded(
                    child: Text(
                      subject.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFFAFB2D0),
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ========================================================
                  // BADGES
                  // ========================================================

                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      _Badge(
                        label: subject.difficulty,
                        color: subject.color,
                      ),
                      _Badge(
                        label: subject.priority,
                        color: const Color(0xFF30345F),
                        textColor:
                            const Color(0xFFD6D8EF),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// SUBJECT ICON
// ============================================================================

class _SubjectIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _SubjectIcon({
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: 0.10,
        ),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: color.withValues(
            alpha: 0.35,
          ),
        ),
      ),
      child: Icon(
        icon,
        color: color,
        size: 28,
      ),
    );
  }
}

// ============================================================================
// BADGE
// ============================================================================

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  final Color? textColor;

  const _Badge({
    required this.label,
    required this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: textColor == null ? 0.13 : 0.28,
        ),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor ?? color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ============================================================================
// LABEL
// ============================================================================

class _Label extends StatelessWidget {
  final String text;

  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

// ============================================================================
// TEXT FIELD
// ============================================================================

class _TextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final int maxLines;

  const _TextField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 13,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFF2D315A),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFF773CFF),
            width: 1.3,
          ),
        ),
      ),
    );
  }
}
// ============================================================================
// COLOR BUTTON
// ============================================================================
class _ColorButton extends StatelessWidget {
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _ColorButton({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 150,
        ),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected
                ? Colors.white
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: color.withValues(
                      alpha: 0.55,
                    ),
                    blurRadius: 13,
                  ),
                ]
              : null,
        ),
        child: selected
            ? const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 19,
              )
            : null,
      ),
    );
  }
}

// ============================================================================
// DROPDOWN
// ============================================================================

class _Dropdown extends StatelessWidget {
  final String label;
  final IconData icon;
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  const _Dropdown({
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
        _Label(label),
        const SizedBox(height: 7),
        DropdownButtonFormField<String>(
          initialValue: value,
          dropdownColor: const Color(0xFF10122F),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFFB4B7D2),
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: const Color(0xFF8D92B7),
              size: 19,
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
                color: Color(0xFF2D315A),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF773CFF),
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
// SUBJECT DATA
// ============================================================================

class _SubjectData {
  String title;
  String description;
  String difficulty;
  String priority;
  Color color;
  IconData icon;

  _SubjectData({
    required this.title,
    required this.description,
    required this.difficulty,
    required this.priority,
    required this.color,
    required this.icon,
  });
}

// ============================================================================
// SUBJECT COLORS
// ============================================================================

const List<Color> _subjectColors = [
  Color(0xFF6735F5),
  Color(0xFF4E39E8),
  Color(0xFFC52AC8),
  Color(0xFFEF4056),
  Color(0xFFFF7518),
  Color(0xFFF1B51C),
  Color(0xFF24B875),
  Color(0xFF14B8C4),
  Color(0xFF1877E8),
];