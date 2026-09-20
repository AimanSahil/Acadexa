import 'package:flutter/material.dart';

import '../../../../core/widgets/main_app_shell.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _currentMonth = DateTime(2026, 8);
  DateTime _selectedDate = DateTime(2026, 8, 23);

  final List<_CalendarEvent> _events = [
    _CalendarEvent(
      date: DateTime(2026, 8, 31),
      type: _EventType.task,
    ),
    _CalendarEvent(
      date: DateTime(2026, 8, 13),
      type: _EventType.exam,
    ),
    _CalendarEvent(
      date: DateTime(2026, 8, 20),
      type: _EventType.exam,
    ),
    _CalendarEvent(
      date: DateTime(2026, 8, 27),
      type: _EventType.exam,
    ),
  ];

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return MainAppShell(
      selectedRoute: '/calendar',
      child: Container(
        color: const Color(0xFF020416),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool mobile = constraints.maxWidth < 750;
            final bool tablet = constraints.maxWidth < 1100;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                mobile
                    ? 16
                    : tablet
                        ? 24
                        : 30,
                mobile ? 22 : 28,
                mobile
                    ? 16
                    : tablet
                        ? 24
                        : 30,
                35,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPageHeader(
                    context,
                    mobile,
                  ),
                  const SizedBox(height: 28),
                  _buildMainContent(
                    context,
                    mobile,
                    tablet,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildPageHeader(
    BuildContext context,
    bool mobile,
  ) {
    if (mobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Calendar',
            style: TextStyle(
              color: Colors.white,
              fontSize: 31,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'Plan your study time and stay ahead of deadlines',
            style: TextStyle(
              color: Color(0xFFA8ABC6),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 18),
          _AddEventButton(
            onPressed: () {
              _showAddEventDialog(context);
            },
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
                'Calendar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1,
                ),
              ),
              SizedBox(height: 7),
              Text(
                'Plan your study time and stay ahead of deadlines',
                style: TextStyle(
                  color: Color(0xFFA8ABC6),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        _AddEventButton(
          onPressed: () {
            _showAddEventDialog(context);
          },
        ),
      ],
    );
  }

  // ============================================================
  // MAIN CONTENT
  // ============================================================

  Widget _buildMainContent(
    BuildContext context,
    bool mobile,
    bool tablet,
  ) {
    if (mobile) {
      return Column(
        children: [
          _buildCalendarCard(context, mobile),
          const SizedBox(height: 18),
          _buildTasksCard(),
          const SizedBox(height: 18),
          _buildDeadlinesCard(),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: tablet ? 3 : 7,
          child: _buildCalendarCard(
            context,
            mobile,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          flex: tablet ? 2 : 3,
          child: Column(
            children: [
              _buildTasksCard(),
              const SizedBox(height: 20),
              _buildDeadlinesCard(),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // CALENDAR CARD
  // ============================================================

  Widget _buildCalendarCard(
    BuildContext context,
    bool mobile,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF05091D),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF252B53),
        ),
      ),
      child: Column(
        children: [
          _buildCalendarHeader(),
          const Divider(
            height: 1,
            color: Color(0xFF202544),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              mobile ? 12 : 24,
              mobile ? 18 : 26,
              mobile ? 12 : 24,
              20,
            ),
            child: _buildCalendarGrid(mobile),
          ),
          const Divider(
            height: 1,
            color: Color(0xFF202544),
          ),
          _buildCalendarLegend(),
        ],
      ),
    );
  }

  // ============================================================
  // CALENDAR HEADER
  // ============================================================

  Widget _buildCalendarHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        27,
        23,
        20,
        22,
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: const Color(0xFF2B1BC9)
                  .withValues(alpha: 0.28),
              borderRadius: BorderRadius.circular(7),
            ),
            child: const Icon(
              Icons.calendar_month_rounded,
              color: Color(0xFF544CFF),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Study calendar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 7),
                Text(
                  'Select a day to see its tasks and exams',
                  style: TextStyle(
                    color: Color(0xFFA9ADCA),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: _goToToday,
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFB69AFF),
              side: const BorderSide(
                color: Color(0xFF303661),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Today',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CALENDAR GRID
  // ============================================================

  Widget _buildCalendarGrid(bool mobile) {
    final DateTime firstDay = DateTime(
      _currentMonth.year,
      _currentMonth.month,
      1,
    );

    final int daysInMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month + 1,
      0,
    ).day;

    // Sunday = 0
    final int firstWeekday =
        firstDay.weekday % 7;

    final int previousMonthDays = DateTime(
      _currentMonth.year,
      _currentMonth.month,
      0,
    ).day;

    final List<_CalendarDay> days = [];

    // Previous month
    for (int i = firstWeekday - 1; i >= 0; i--) {
      days.add(
        _CalendarDay(
          date: DateTime(
            _currentMonth.year,
            _currentMonth.month - 1,
            previousMonthDays - i,
          ),
          isCurrentMonth: false,
        ),
      );
    }

    // Current month
    for (int day = 1; day <= daysInMonth; day++) {
      days.add(
        _CalendarDay(
          date: DateTime(
            _currentMonth.year,
            _currentMonth.month,
            day,
          ),
          isCurrentMonth: true,
        ),
      );
    }

    // Next month
    int nextDay = 1;

    while (days.length < 42) {
      days.add(
        _CalendarDay(
          date: DateTime(
            _currentMonth.year,
            _currentMonth.month + 1,
            nextDay++,
          ),
          isCurrentMonth: false,
        ),
      );
    }

    final String monthName =
        _monthName(_currentMonth.month);

    if (mobile) {
      return Column(
        children: [
          _buildMonthNavigation(monthName),
          const SizedBox(height: 18),
          _buildWeekdayHeader(),
          const SizedBox(height: 7),
          GridView.builder(
            shrinkWrap: true,
            physics:
                const NeverScrollableScrollPhysics(),
            itemCount: days.length,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              return _buildDayCell(
                days[index],
                mobile,
              );
            },
          ),
        ],
      );
    }

    return Column(
      children: [
        _buildMonthNavigation(monthName),
        const SizedBox(height: 22),
        _buildWeekdayHeader(),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics:
              const NeverScrollableScrollPhysics(),
          itemCount: days.length,
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1.45,
          ),
          itemBuilder: (context, index) {
            return _buildDayCell(
              days[index],
              mobile,
            );
          },
        ),
      ],
    );
  }

  // ============================================================
  // MONTH NAVIGATION
  // ============================================================

  Widget _buildMonthNavigation(
    String monthName,
  ) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              _currentMonth = DateTime(
                _currentMonth.year,
                _currentMonth.month - 1,
              );
            });
          },
          icon: const Icon(
            Icons.chevron_left_rounded,
            color: Colors.white,
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              '$monthName ${_currentMonth.year}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _currentMonth = DateTime(
                _currentMonth.year,
                _currentMonth.month + 1,
              );
            });
          },
          icon: const Icon(
            Icons.chevron_right_rounded,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // WEEKDAYS
  // ============================================================

  Widget _buildWeekdayHeader() {
    const weekdays = [
      'Su',
      'Mo',
      'Tu',
      'We',
      'Th',
      'Fr',
      'Sa',
    ];

    return Row(
      children: [
        for (final day in weekdays)
          Expanded(
            child: Center(
              child: Text(
                day,
                style: const TextStyle(
                  color: Color(0xFFB8BCD5),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }

  // ============================================================
  // DAY CELL
  // ============================================================

  Widget _buildDayCell(
    _CalendarDay calendarDay,
    bool mobile,
  ) {
    final DateTime date = calendarDay.date;

    final bool selected =
        _isSameDate(date, _selectedDate);

    final _EventType? eventType =
        _eventTypeFor(date);

    final bool isToday = _isSameDate(
      date,
      DateTime.now(),
    );

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDate = date;

          if (!calendarDay.isCurrentMonth) {
            _currentMonth = DateTime(
              date.year,
              date.month,
            );
          }
        });
      },
      child: Container(
        margin: EdgeInsets.all(
          mobile ? 2 : 4,
        ),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF2638F2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(
            selected ? 9 : 6,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Text(
                '${date.day}',
                style: TextStyle(
                  color: selected
                      ? Colors.white
                      : calendarDay.isCurrentMonth
                          ? Colors.white
                          : const Color(0xFF71758F),
                  fontSize: mobile ? 13 : 16,
                  fontWeight: selected || isToday
                      ? FontWeight.w600
                      : FontWeight.w400,
                ),
              ),
              const SizedBox(height: 5),
              if (eventType != null)
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: eventType ==
                            _EventType.exam
                        ? const Color(0xFFFF3B63)
                        : const Color(0xFF3266FF),
                    shape: BoxShape.circle,
                  ),
                )
              else
                const SizedBox(height: 7),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // LEGEND
  // ============================================================

  Widget _buildCalendarLegend() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 27,
        vertical: 17,
      ),
      child: Row(
        children: [
          _LegendItem(
            color: const Color(0xFF3266FF),
            label: 'Task deadline',
          ),
          const SizedBox(width: 24),
          _LegendItem(
            color: const Color(0xFFFF3B63),
            label: 'Exam',
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TODAY'S TASKS
  // ============================================================

  Widget _buildTasksCard() {
    return _SideCard(
      title: "Today's tasks",
      icon: Icons.format_list_bulleted_rounded,
      child: Column(
        children: const [
          _TaskItem(
            title: 'Implement binary search tree',
            duration: '60 min',
            priority: 'High',
            priorityColor: Color(0xFF4030A5),
          ),
          SizedBox(height: 8),
          _TaskItem(
            title: 'Review sorting algorithms',
            duration: '45 min',
            priority: 'Medium',
            priorityColor: Color(0xFF173D82),
          ),
          SizedBox(height: 8),
          _TaskItem(
            title: 'Build React portfolio homepage',
            duration: '90 min',
            priority: 'High',
            priorityColor: Color(0xFF4030A5),
          ),
          SizedBox(height: 8),
          _TaskItem(
            title: 'Practice multivariable integrals',
            duration: '75 min',
            priority: 'High',
            priorityColor: Color(0xFF4030A5),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DEADLINES
  // ============================================================

  Widget _buildDeadlinesCard() {
    return _SideCard(
      title: 'Upcoming deadlines',
      icon: Icons.calendar_month_rounded,
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Next 14 days',
            style: TextStyle(
              color: Color(0xFFA0A4C2),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF080C25),
              borderRadius:
                  BorderRadius.circular(9),
              border: Border.all(
                color: const Color(0xFF20274A),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFF7A1C4C)
                        .withValues(alpha: 0.55),
                    borderRadius:
                        BorderRadius.circular(9),
                  ),
                  child: const Icon(
                    Icons.school_rounded,
                    color: Color(0xFFFF4F72),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Web Dev Project Demo',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Thu, Aug 27',
                        style: TextStyle(
                          color: Color(0xFFA5A9C6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8D2346),
                    borderRadius:
                        BorderRadius.circular(7),
                  ),
                  child: const Text(
                    'Exam',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ADD EVENT DIALOG
  // ============================================================

  void _showAddEventDialog(
    BuildContext context,
  ) {
    final titleController =
        TextEditingController();

    String eventType = 'Task';
    DateTime eventDate = _selectedDate;

    showDialog<void>(
      context: context,
      barrierColor:
          Colors.black.withValues(alpha: 0.78),
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (
            context,
            setDialogState,
          ) {
            return Dialog(
              backgroundColor:
                  const Color(0xFF080A29),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(16),
                side: const BorderSide(
                  color: Color(0xFF5831A7),
                ),
              ),
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(
                  maxWidth: 470,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(
                    28,
                  ),
                  child: Column(
                    mainAxisSize:
                        MainAxisSize.min,
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Add Event',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
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
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const _DialogLabel(
                        'Event title',
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller:
                            titleController,
                        style:
                            const TextStyle(
                          color: Colors.white,
                        ),
                        decoration:
                            const InputDecoration(
                          hintText:
                              'e.g. Study Data Structures',
                          hintStyle: TextStyle(
                            color:
                                Color(0xFF7F84A4),
                          ),
                          prefixIcon: Icon(
                            Icons.event_outlined,
                            color:
                                Color(0xFF8754FF),
                          ),
                          filled: true,
                          fillColor:
                              Color(0xFF06081E),
                          enabledBorder:
                              OutlineInputBorder(
                            borderSide:
                                BorderSide(
                              color:
                                  Color(0xFF30345A),
                            ),
                          ),
                          focusedBorder:
                              OutlineInputBorder(
                            borderSide:
                                BorderSide(
                              color:
                                  Color(0xFF793DFF),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      const _DialogLabel(
                        'Event type',
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<
                          String>(
                        initialValue: eventType,
                        dropdownColor:
                            const Color(
                          0xFF10122F,
                        ),
                        style:
                            const TextStyle(
                          color: Colors.white,
                        ),
                        decoration:
                            const InputDecoration(
                          prefixIcon: Icon(
                            Icons.category_outlined,
                            color:
                                Color(0xFF8754FF),
                          ),
                          filled: true,
                          fillColor:
                              Color(0xFF06081E),
                          enabledBorder:
                              OutlineInputBorder(
                            borderSide:
                                BorderSide(
                              color:
                                  Color(0xFF30345A),
                            ),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Task',
                            child: Text('Task'),
                          ),
                          DropdownMenuItem(
                            value: 'Exam',
                            child: Text('Exam'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setDialogState(() {
                              eventType = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 18),
                      const _DialogLabel(
                        'Date',
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () async {
                          final date =
                              await showDatePicker(
                            context: context,
                            initialDate:
                                eventDate,
                            firstDate:
                                DateTime(2020),
                            lastDate:
                                DateTime(2100),
                            builder: (
                              context,
                              child,
                            ) {
                              return Theme(
                                data: Theme.of(
                                  context,
                                ).copyWith(
                                  colorScheme:
                                      const ColorScheme
                                          .dark(
                                    primary:
                                        Color(
                                      0xFF7136F4,
                                    ),
                                    surface:
                                        Color(
                                      0xFF0A0D2C,
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );

                          if (date != null) {
                            setDialogState(() {
                              eventDate = date;
                            });
                          }
                        },
                        borderRadius:
                            BorderRadius.circular(8),
                        child: Container(
                          height: 50,
                          padding:
                              const EdgeInsets
                                  .symmetric(
                            horizontal: 14,
                          ),
                          decoration:
                              BoxDecoration(
                            color:
                                const Color(
                              0xFF06081E,
                            ),
                            borderRadius:
                                BorderRadius.circular(
                              8,
                            ),
                            border: Border.all(
                              color:
                                  const Color(
                                0xFF30345A,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons
                                    .calendar_month_outlined,
                                color:
                                    Color(0xFF8754FF),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                _formatFullDate(
                                  eventDate,
                                ),
                                style:
                                    const TextStyle(
                                  color:
                                      Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(
                                dialogContext,
                              );
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color:
                                    Color(0xFFB99AFF),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          FilledButton(
                            onPressed: () {
                              final title =
                                  titleController
                                      .text
                                      .trim();

                              if (title.isEmpty) {
                                ScaffoldMessenger
                                    .of(context)
                                    .showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Enter an event title.',
                                    ),
                                  ),
                                );
                                return;
                              }

                              setState(() {
                                _events.add(
                                  _CalendarEvent(
                                    date: eventDate,
                                    type: eventType ==
                                            'Exam'
                                        ? _EventType
                                            .exam
                                        : _EventType
                                            .task,
                                  ),
                                );
                              });

                              Navigator.pop(
                                dialogContext,
                              );

                              ScaffoldMessenger
                                  .of(context)
                                  .showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Event added to calendar.',
                                  ),
                                ),
                              );
                            },
                            style:
                                FilledButton.styleFrom(
                              backgroundColor:
                                  const Color(
                                0xFF6817EA,
                              ),
                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                horizontal: 20,
                                vertical: 13,
                              ),
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  8,
                                ),
                              ),
                            ),
                            child: const Text(
                              'Add Event',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ============================================================
  // TODAY
  // ============================================================

  void _goToToday() {
    final DateTime today = DateTime.now();

    setState(() {
      _currentMonth = DateTime(
        today.year,
        today.month,
      );
      _selectedDate = DateTime(
        today.year,
        today.month,
        today.day,
      );
    });
  }

  // ============================================================
  // EVENT TYPE
  // ============================================================

  _EventType? _eventTypeFor(
    DateTime date,
  ) {
    for (final event in _events) {
      if (_isSameDate(event.date, date)) {
        return event.type;
      }
    }

    return null;
  }

  // ============================================================
  // DATE HELPERS
  // ============================================================

  bool _isSameDate(
    DateTime first,
    DateTime second,
  ) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return months[month - 1];
  }

  String _formatFullDate(DateTime date) {
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

// ============================================================================
// ADD EVENT BUTTON
// ============================================================================

class _AddEventButton extends StatefulWidget {
  final VoidCallback onPressed;

  const _AddEventButton({
    required this.onPressed,
  });

  @override
  State<_AddEventButton> createState() =>
      _AddEventButtonState();
}

class _AddEventButtonState
    extends State<_AddEventButton> {
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
        duration:
            const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF3432ED),
              Color(0xFF8613E7),
            ],
          ),
          borderRadius:
              BorderRadius.circular(9),
          boxShadow: hovered
              ? [
                  BoxShadow(
                    color: const Color(
                      0xFF6932F5,
                    ).withValues(alpha: 0.28),
                    blurRadius: 22,
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onPressed,
            borderRadius:
                BorderRadius.circular(9),
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 19,
                vertical: 13,
              ),
              child: Row(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Add Event',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight:
                          FontWeight.w600,
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
// SIDE CARD
// ============================================================================

class _SideCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SideCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF05091D),
        borderRadius:
            BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF252B53),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: const Color(0xFF3C63FF),
                size: 22,
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

// ============================================================================
// TASK ITEM
// ============================================================================

class _TaskItem extends StatelessWidget {
  final String title;
  final String duration;
  final String priority;
  final Color priorityColor;

  const _TaskItem({
    required this.title,
    required this.duration,
    required this.priority,
    required this.priorityColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF070B23),
        borderRadius:
            BorderRadius.circular(9),
        border: Border.all(
          color: const Color(0xFF22294D),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 21,
            height: 21,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF566083),
                width: 1.5,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.schedule_outlined,
                      color: Color(0xFFA4A8C4),
                      size: 14,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      duration,
                      style: const TextStyle(
                        color:
                            Color(0xFFA4A8C4),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: priorityColor,
              borderRadius:
                  BorderRadius.circular(6),
            ),
            child: Text(
              priority,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// LEGEND ITEM
// ============================================================================

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFB4B8D1),
            fontSize: 13,
          ),
        ),
      ],
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
// MODELS
// ============================================================================

enum _EventType {
  task,
  exam,
}

class _CalendarEvent {
  final DateTime date;
  final _EventType type;

  const _CalendarEvent({
    required this.date,
    required this.type,
  });
}

class _CalendarDay {
  final DateTime date;
  final bool isCurrentMonth;

  const _CalendarDay({
    required this.date,
    required this.isCurrentMonth,
  });
}