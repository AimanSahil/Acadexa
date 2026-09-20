import 'package:flutter/material.dart';

import '../../../../core/widgets/main_app_shell.dart';

enum TaskStatus {
  todo,
  inProgress,
  completed,
  missed,
}

class TaskItem {
  TaskItem({
    required this.title,
    required this.subject,
    required this.duration,
    required this.dueDate,
    required this.priority,
    this.description = '',
    this.status = TaskStatus.todo,
  });

  String title;
  String subject;
  int duration;
  String dueDate;
  String priority;
  String description;
  TaskStatus status;
}

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  TaskStatus _selectedStatus = TaskStatus.todo;

  final List<TaskItem> _tasks = [
    TaskItem(
      title: 'Implement binary search tree',
      subject: 'Data Structures',
      duration: 60,
      dueDate: 'Jul 12',
      priority: 'High',
    ),
    TaskItem(
      title: 'Review sorting algorithms',
      subject: 'Data Structures',
      duration: 45,
      dueDate: 'Jul 14',
      priority: 'Medium',
    ),
    TaskItem(
      title: 'Build React portfolio homepage',
      subject: 'Web Development',
      duration: 90,
      dueDate: 'Aug 2',
      priority: 'High',
    ),
    TaskItem(
      title: 'Practice multivariable integrals',
      subject: 'Calculus II',
      duration: 75,
      dueDate: 'Jul 19',
      priority: 'High',
    ),
  ];

  List<TaskItem> get _visibleTasks {
    return _tasks
        .where((task) => task.status == _selectedStatus)
        .toList();
  }

  String get _emptyTitle {
    switch (_selectedStatus) {
      case TaskStatus.todo:
        return 'No tasks yet';
      case TaskStatus.inProgress:
        return 'No in progress tasks';
      case TaskStatus.completed:
        return 'No completed tasks';
      case TaskStatus.missed:
        return 'No missed tasks';
    }
  }

  String get _emptyDescription {
    switch (_selectedStatus) {
      case TaskStatus.todo:
        return 'Create a task to get started and stay on track.';
      case TaskStatus.inProgress:
        return 'Create a task to get started with your study plan.';
      case TaskStatus.completed:
        return 'Great job! You haven’t completed any tasks yet.\n'
            'Complete tasks to see them here.';
      case TaskStatus.missed:
        return 'Looks like you haven’t missed any tasks.\n'
            'Great job! Keep up the good work.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainAppShell(
      selectedRoute: '/tasks',
      child: Container(
        color: const Color(0xFF020617),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isMobile = constraints.maxWidth < 700;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                isMobile ? 18 : 42,
                isMobile ? 24 : 34,
                isMobile ? 18 : 42,
                40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(isMobile),
                  const SizedBox(height: 28),
                  _buildTabs(isMobile),
                  const SizedBox(height: 28),
                  if (_visibleTasks.isEmpty)
                    _buildEmptyState()
                  else
                    _buildTaskList(isMobile),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tasks',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w700,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Organize and track your study tasks.',
            style: TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 18),
          _buildAddTaskButton(),
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
                'Tasks',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Organize and track your study tasks.',
                style: TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        _buildAddTaskButton(),
      ],
    );
  }

  Widget _buildAddTaskButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _showCreateTaskDialog,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 13,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF4F18E8),
                Color(0xFF8B20F4),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6D28D9).withOpacity(0.28),
                blurRadius: 20,
                spreadRadius: -5,
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 21,
              ),
              SizedBox(width: 8),
              Text(
                'Add Task',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabs(bool isMobile) {
    final tabs = [
      (
        label: 'To Do',
        status: TaskStatus.todo,
      ),
      (
        label: 'In Progress',
        status: TaskStatus.inProgress,
      ),
      (
        label: 'Completed',
        status: TaskStatus.completed,
      ),
      (
        label: 'Missed',
        status: TaskStatus.missed,
      ),
    ];

    return Container(
      width: isMobile ? double.infinity : 520,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF050A1D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF1C2442),
        ),
      ),
      child: Row(
        children: tabs.map((tab) {
          final bool selected = _selectedStatus == tab.status;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedStatus = tab.status;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                  vertical: 11,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  gradient: selected
                      ? const LinearGradient(
                          colors: [
                            Color(0xFF4320D8),
                            Color(0xFF6618E8),
                          ],
                        )
                      : null,
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: const Color(0xFF6D28D9)
                                .withOpacity(0.25),
                            blurRadius: 12,
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    tab.label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: selected
                          ? Colors.white
                          : const Color(0xFFB5BAD0),
                      fontSize: 14,
                      fontWeight: selected
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTaskList(bool isMobile) {
    return Column(
      children: _visibleTasks.map((task) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 18),
          child: _TaskCard(
            task: task,
            isMobile: isMobile,
            onComplete: () => _completeTask(task),
            onDelete: () => _deleteTask(task),
            onMoveToProgress: () => _moveToProgress(task),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEmptyState() {
    final bool missed = _selectedStatus == TaskStatus.missed;

    return Padding(
      padding: const EdgeInsets.only(
        top: 110,
        bottom: 100,
      ),
      child: Center(
        child: Column(
          children: [
            SizedBox(
              width: 145,
              height: 145,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF060B23),
                      border: Border.all(
                        color: missed
                            ? const Color(0xFF41203B)
                            : const Color(0xFF25205B),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: missed
                              ? const Color(0xFFEF4444)
                                  .withOpacity(0.08)
                              : const Color(0xFF7C3AED)
                                  .withOpacity(0.08),
                          blurRadius: 35,
                          spreadRadius: 8,
                        ),
                      ],
                    ),
                    child: Icon(
                      missed
                          ? Icons.assignment_late_outlined
                          : Icons.checklist_rounded,
                      size: 66,
                      color: missed
                          ? const Color(0xFF8D68D8)
                          : const Color(0xFF7C3AED),
                    ),
                  ),
                  Positioned(
                    top: 7,
                    right: 10,
                    child: Icon(
                      Icons.auto_awesome,
                      size: 17,
                      color: missed
                          ? const Color(0xFFEF476F)
                          : const Color(0xFF7C3AED),
                    ),
                  ),
                  Positioned(
                    left: 8,
                    top: 58,
                    child: Icon(
                      Icons.auto_awesome,
                      size: 13,
                      color: missed
                          ? const Color(0xFFEF476F)
                          : const Color(0xFF7C3AED),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text(
              _emptyTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _emptyDescription,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFB8BDD0),
                fontSize: 16,
                height: 1.65,
              ),
            ),
            const SizedBox(height: 28),
            _buildEmptyAddButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyAddButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _showCreateTaskDialog,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF4F18E8),
                Color(0xFF7C20ED),
              ],
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 21,
              ),
              SizedBox(width: 9),
              Text(
                'Add Task',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _completeTask(TaskItem task) {
    setState(() {
      task.status = TaskStatus.completed;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Task completed'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _moveToProgress(TaskItem task) {
    setState(() {
      task.status = TaskStatus.inProgress;
    });

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Task moved to In Progress'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _deleteTask(TaskItem task) {
    setState(() {
      _tasks.remove(task);
    });

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Task deleted'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _showCreateTaskDialog() async {
    final TextEditingController titleController =
        TextEditingController();

    final TextEditingController descriptionController =
        TextEditingController();

    final TextEditingController dueDateController =
        TextEditingController();

    String priority = 'Medium';
    String duration = '30';
    String subject = 'Select subject';

    await showDialog<void>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.72),
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 24,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 540,
                ),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(
                    30,
                    27,
                    30,
                    24,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF080D23),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF6735C9),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF5B21B6)
                            .withOpacity(0.16),
                        blurRadius: 35,
                        spreadRadius: 4,
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
                            const Expanded(
                              child: Text(
                                'Create New Task',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 21,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                              },
                              icon: const Icon(
                                Icons.close_rounded,
                                color: Color(0xFFB9BED1),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        _dialogLabel('Title'),
                        const SizedBox(height: 8),
                        _dialogTextField(
                          controller: titleController,
                          hint: 'e.g. Review Chapter 3',
                          icon: Icons.assignment_outlined,
                          autofocus: true,
                        ),
                        const SizedBox(height: 19),
                        _dialogLabel(
                          'Description',
                          optional: true,
                        ),
                        const SizedBox(height: 8),
                        _dialogTextField(
                          controller: descriptionController,
                          hint: 'Task details...',
                          icon: Icons.description_outlined,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 19),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth < 420) {
                              return Column(
                                children: [
                                  _buildDialogDropdown(
                                    label: 'Priority',
                                    value: priority,
                                    icon: Icons.flag_outlined,
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
                                  const SizedBox(height: 16),
                                  _buildDialogDropdown(
                                    label: 'Duration (mins)',
                                    value: duration,
                                    icon: Icons.schedule_outlined,
                                    items: const [
                                      '15',
                                      '30',
                                      '45',
                                      '60',
                                      '90',
                                      '120',
                                    ],
                                    onChanged: (value) {
                                      setDialogState(() {
                                        duration = value;
                                      });
                                    },
                                  ),
                                ],
                              );
                            }

                            return Row(
                              children: [
                                Expanded(
                                  child: _buildDialogDropdown(
                                    label: 'Priority',
                                    value: priority,
                                    icon: Icons.flag_outlined,
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
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildDialogDropdown(
                                    label: 'Duration (mins)',
                                    value: duration,
                                    icon: Icons.schedule_outlined,
                                    items: const [
                                      '15',
                                      '30',
                                      '45',
                                      '60',
                                      '90',
                                      '120',
                                    ],
                                    onChanged: (value) {
                                      setDialogState(() {
                                        duration = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 19),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth < 420) {
                              return Column(
                                children: [
                                  _buildDateField(
                                    controller: dueDateController,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildDialogDropdown(
                                    label: 'Subject',
                                    value: subject,
                                    icon: Icons.menu_book_outlined,
                                    items: const [
                                      'Select subject',
                                      'Data Structures',
                                      'Calculus II',
                                      'Web Development',
                                    ],
                                    onChanged: (value) {
                                      setDialogState(() {
                                        subject = value;
                                      });
                                    },
                                  ),
                                ],
                              );
                            }

                            return Row(
                              children: [
                                Expanded(
                                  child: _buildDateField(
                                    controller:
                                        dueDateController,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildDialogDropdown(
                                    label: 'Subject',
                                    value: subject,
                                    icon:
                                        Icons.menu_book_outlined,
                                    items: const [
                                      'Select subject',
                                      'Data Structures',
                                      'Calculus II',
                                      'Web Development',
                                    ],
                                    onChanged: (value) {
                                      setDialogState(() {
                                        subject = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 25),
                        Align(
                          alignment: Alignment.centerRight,
                          child: _gradientButton(
                            label: 'Create Task',
                            onTap: () {
                              final String title =
                                  titleController.text.trim();

                              if (title.isEmpty) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please enter a task title',
                                    ),
                                    behavior:
                                        SnackBarBehavior.floating,
                                  ),
                                );
                                return;
                              }

                              setState(() {
                                _tasks.add(
                                  TaskItem(
                                    title: title,
                                    subject: subject ==
                                            'Select subject'
                                        ? 'General'
                                        : subject,
                                    duration:
                                        int.tryParse(duration) ??
                                            30,
                                    dueDate:
                                        dueDateController.text
                                                .trim()
                                                .isEmpty
                                            ? 'No date'
                                            : dueDateController
                                                .text
                                                .trim(),
                                    priority: priority,
                                    description:
                                        descriptionController
                                            .text
                                            .trim(),
                                  ),
                                );

                                _selectedStatus =
                                    TaskStatus.todo;
                              });

                              Navigator.of(dialogContext).pop();

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Task created'),
                                  behavior:
                                      SnackBarBehavior.floating,
                                ),
                              );
                            },
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

    titleController.dispose();
    descriptionController.dispose();
    dueDateController.dispose();
  }

  Widget _dialogLabel(
    String text, {
    bool optional = false,
  }) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (optional)
            const TextSpan(
              text: ' (optional)',
              style: TextStyle(
                color: Color(0xFF8F96AD),
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
        ],
      ),
    );
  }

  Widget _dialogTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    bool autofocus = false,
  }) {
    return TextField(
      controller: controller,
      autofocus: autofocus,
      maxLines: maxLines,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
      cursorColor: const Color(0xFF8B5CF6),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFF737B95),
          fontSize: 14,
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.only(
            left: 13,
            right: maxLines > 1 ? 4 : 10,
            top: maxLines > 1 ? 12 : 0,
          ),
          child: Icon(
            icon,
            color: const Color(0xFF8B5CF6),
            size: 19,
          ),
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 42,
        ),
        filled: true,
        fillColor: const Color(0xFF070C21),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFF252D4A),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFF8B5CF6),
          ),
        ),
      ),
    );
  }

  Widget _buildDialogDropdown({
    required String label,
    required String value,
    required IconData icon,
    required List<String> items,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _dialogLabel(label),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          dropdownColor: const Color(0xFF0B1028),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFFB7BDD0),
          ),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: const Color(0xFF8B5CF6),
              size: 19,
            ),
            filled: true,
            fillColor: const Color(0xFF070C21),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 4,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF252D4A),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF8B5CF6),
              ),
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
        ),
      ],
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _dialogLabel('Due Date'),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: true,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
          onTap: () async {
            final DateTime? date = await showDatePicker(
              context: context,
              firstDate: DateTime(2020),
              lastDate: DateTime(2100),
              initialDate: DateTime.now(),
              builder: (context, child) {
                return Theme(
                  data: ThemeData.dark().copyWith(
                    colorScheme: const ColorScheme.dark(
                      primary: Color(0xFF7C3AED),
                      surface: Color(0xFF0A1027),
                    ),
                  ),
                  child: child!,
                );
              },
            );

            if (date != null) {
              controller.text =
                  '${_monthName(date.month)} ${date.day}';
            }
          },
          decoration: InputDecoration(
            hintText: 'mm/dd/yyyy',
            hintStyle: const TextStyle(
              color: Color(0xFF737B95),
              fontSize: 14,
            ),
            prefixIcon: const Icon(
              Icons.calendar_today_outlined,
              color: Color(0xFF8B5CF6),
              size: 18,
            ),
            suffixIcon: const Icon(
              Icons.calendar_month_outlined,
              color: Color(0xFFB7BDD0),
              size: 18,
            ),
            filled: true,
            fillColor: const Color(0xFF070C21),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF252D4A),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF8B5CF6),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _gradientButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: Ink(
          padding: const EdgeInsets.symmetric(
            horizontal: 21,
            vertical: 13,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF4F18E8),
                Color(0xFF7C20ED),
              ],
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  String _monthName(int month) {
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

    return months[month - 1];
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({
    required this.task,
    required this.isMobile,
    required this.onComplete,
    required this.onDelete,
    required this.onMoveToProgress,
  });

  final TaskItem task;
  final bool isMobile;
  final VoidCallback onComplete;
  final VoidCallback onDelete;
  final VoidCallback onMoveToProgress;

  @override
  Widget build(BuildContext context) {
    final Color priorityColor = _priorityColor(task.priority);
    final Color subjectColor = _subjectColor(task.subject);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 18 : 26,
        vertical: isMobile ? 18 : 22,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF05091B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF18203B),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: isMobile
          ? _buildMobileLayout(
              context,
              subjectColor,
              priorityColor,
            )
          : _buildDesktopLayout(
              context,
              subjectColor,
              priorityColor,
            ),
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    Color subjectColor,
    Color priorityColor,
  ) {
    return Row(
      children: [
        _buildCheckbox(),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 26,
                runSpacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _buildBadge(
                    task.subject,
                    subjectColor,
                  ),
                  _buildInfo(
                    Icons.schedule_outlined,
                    '${task.duration} min',
                  ),
                  _buildInfo(
                    Icons.calendar_today_outlined,
                    'Due ${task.dueDate}',
                  ),
                  _buildBadge(
                    task.priority,
                    priorityColor,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        _buildMoreButton(context),
        const SizedBox(width: 14),
        _buildDeleteButton(),
      ],
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    Color subjectColor,
    Color priorityColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildCheckbox(),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                task.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            _buildMoreButton(context),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 10,
          children: [
            _buildBadge(
              task.subject,
              subjectColor,
            ),
            _buildInfo(
              Icons.schedule_outlined,
              '${task.duration} min',
            ),
            _buildInfo(
              Icons.calendar_today_outlined,
              'Due ${task.dueDate}',
            ),
            _buildBadge(
              task.priority,
              priorityColor,
            ),
          ],
        ),
        const SizedBox(height: 14),
        Align(
          alignment: Alignment.centerRight,
          child: _buildDeleteButton(),
        ),
      ],
    );
  }

  Widget _buildCheckbox() {
    return InkWell(
      onTap: onComplete,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 31,
        height: 31,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          border: Border.all(
            color: const Color(0xFF8B3DF5),
            width: 2,
          ),
        ),
        child: task.status == TaskStatus.completed
            ? const Icon(
                Icons.check_rounded,
                color: Color(0xFF9B5CFF),
                size: 20,
              )
            : null,
      ),
    );
  }

  Widget _buildBadge(
    String text,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.10),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildInfo(
    IconData icon,
    String text,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: const Color(0xFF9B5CFF),
          size: 18,
        ),
        const SizedBox(width: 7),
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFFD1D5E4),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildMoreButton(BuildContext context) {
    return PopupMenuButton<String>(
      color: const Color(0xFF0B1027),
      icon: const Icon(
        Icons.more_vert_rounded,
        color: Color(0xFF7D849C),
      ),
      onSelected: (value) {
        if (value == 'progress') {
          onMoveToProgress();
        }

        if (value == 'delete') {
          onDelete();
        }
      },
      itemBuilder: (context) {
        return [
          const PopupMenuItem<String>(
            value: 'progress',
            child: Row(
              children: [
                Icon(
                  Icons.play_circle_outline_rounded,
                  color: Color(0xFF9B5CFF),
                  size: 19,
                ),
                SizedBox(width: 10),
                Text(
                  'Move to In Progress',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const PopupMenuItem<String>(
            value: 'delete',
            child: Row(
              children: [
                Icon(
                  Icons.delete_outline_rounded,
                  color: Color(0xFFFF4D67),
                  size: 19,
                ),
                SizedBox(width: 10),
                Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ];
      },
    );
  }

  Widget _buildDeleteButton() {
    return InkWell(
      onTap: onDelete,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFF651526),
          ),
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: Color(0xFFFF2449),
          size: 23,
        ),
      ),
    );
  }

  Color _priorityColor(String priority) {
    switch (priority) {
      case 'High':
        return const Color(0xFFFF3150);
      case 'Medium':
        return const Color(0xFFFFA126);
      default:
        return const Color(0xFF6B8BFF);
    }
  }

  Color _subjectColor(String subject) {
    switch (subject) {
      case 'Web Development':
        return const Color(0xFF00D98B);
      case 'Calculus II':
        return const Color(0xFFFF3EB5);
      case 'Data Structures':
        return const Color(0xFF9B4DFF);
      default:
        return const Color(0xFF8B5CF6);
    }
  }
}