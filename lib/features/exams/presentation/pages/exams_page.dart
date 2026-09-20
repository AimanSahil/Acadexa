import 'package:flutter/material.dart';

import '../../../../core/widgets/main_app_shell.dart';

class ExamsPage extends StatefulWidget {
  const ExamsPage({super.key});

  @override
  State<ExamsPage> createState() => _ExamsPageState();
}

class _ExamsPageState extends State<ExamsPage> {
  final List<_ExamData> _exams = [
    _ExamData(
      title: 'Data Structures Midterm',
      room: 'CSE 201',
      date: 'May 12, 2024',
      time: '10:00 AM',
      priority: 'High',
      color: const Color(0xFF8B5CF6),
      icon: Icons.description_outlined,
      countdown: '14d 5h',
    ),
    _ExamData(
      title: 'Calculus II Final',
      room: 'MATH 301',
      date: 'May 19, 2024',
      time: '2:00 PM',
      priority: 'High',
      color: const Color(0xFFB15CFF),
      icon: Icons.functions_rounded,
      countdown: '21d 9h',
    ),
    _ExamData(
      title: 'Web Dev Project Demo',
      room: 'CSE 309',
      date: 'Jun 2, 2024',
      time: '10:00 AM',
      priority: 'Medium',
      color: const Color(0xFF8B5CF6),
      icon: Icons.code_rounded,
      countdown: '35d 5h',
    ),
  ];

  void _showAddExamDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.72),
      builder: (_) {
        return _AddExamDialog(
          onAdd: (exam) {
            setState(() {
              _exams.add(exam);
            });
          },
        );
      },
    );
  }

  void _deleteExam(int index) {
    final String title = _exams[index].title;

    setState(() {
      _exams.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF11152B),
        content: Text(
          '$title deleted',
          style: const TextStyle(color: Colors.white),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainAppShell(
      selectedRoute: '/exams',
      child: Container(
        color: const Color(0xFF020617),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isMobile = constraints.maxWidth < 700;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                isMobile ? 18 : 48,
                isMobile ? 24 : 32,
                isMobile ? 18 : 48,
                40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(isMobile),
                  const SizedBox(height: 28),
                  _buildExamList(isMobile),
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
            'Exams',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Track your upcoming exams and prepare effectively.',
            style: TextStyle(
              color: Color(0xFF9CA3C7),
              fontSize: 15,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          _addExamButton(),
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
                'Exams',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Track your upcoming exams and prepare effectively.',
                style: TextStyle(
                  color: Color(0xFF9CA3C7),
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
        _addExamButton(),
      ],
    );
  }

  Widget _addExamButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _showAddExamDialog,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF4324E8),
                Color(0xFF8B16E8),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6D28D9).withValues(alpha: 0.22),
                blurRadius: 18,
                spreadRadius: 1,
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
                'Add Exam',
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

  Widget _buildExamList(bool isMobile) {
    if (_exams.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        for (int i = 0; i < _exams.length; i++) ...[
          _ExamCard(
            exam: _exams[i],
            isMobile: isMobile,
            onDelete: () => _deleteExam(i),
          ),
          if (i != _exams.length - 1)
            SizedBox(height: isMobile ? 14 : 24),
        ],
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(
        vertical: 70,
        horizontal: 30,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF05091B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF1B2140),
        ),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.event_available_rounded,
            color: Color(0xFF7C3AED),
            size: 58,
          ),
          SizedBox(height: 18),
          Text(
            'No exams yet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add your upcoming exams to keep track of your preparation.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF8E96B8),
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// EXAM CARD
// ============================================================

class _ExamCard extends StatefulWidget {
  const _ExamCard({
    required this.exam,
    required this.isMobile,
    required this.onDelete,
  });

  final _ExamData exam;
  final bool isMobile;
  final VoidCallback onDelete;

  @override
  State<_ExamCard> createState() => _ExamCardState();
}

class _ExamCardState extends State<_ExamCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final _ExamData exam = widget.exam;

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
        width: double.infinity,
        padding: EdgeInsets.all(widget.isMobile ? 18 : 28),
        decoration: BoxDecoration(
          color: _hovered
              ? const Color(0xFF070C22)
              : const Color(0xFF04081A),
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: _hovered
                ? const Color(0xFF6535D9)
                : const Color(0xFF1A2141),
            width: 1,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: const Color(0xFF6D28D9).withValues(alpha: 0.12),
                    blurRadius: 24,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: widget.isMobile
            ? _buildMobileContent(exam)
            : _buildDesktopContent(exam),
      ),
    );
  }

  Widget _buildDesktopContent(_ExamData exam) {
    return Row(
      children: [
        _buildIcon(exam),
        const SizedBox(width: 28),
        Expanded(
          child: _buildInformation(exam),
        ),
        const SizedBox(width: 20),
        _buildCountdown(exam),
        const SizedBox(width: 26),
        _buildDeleteButton(),
      ],
    );
  }

  Widget _buildMobileContent(_ExamData exam) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIcon(exam),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                exam.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            _buildDeleteButton(),
          ],
        ),
        const SizedBox(height: 18),
        _buildInformation(exam),
        const SizedBox(height: 18),
        _buildCountdown(exam),
      ],
    );
  }

  Widget _buildIcon(_ExamData exam) {
    return Container(
      width: 86,
      height: 86,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF090C2B),
        border: Border.all(
          color: exam.color.withValues(alpha: 0.55),
        ),
        boxShadow: [
          BoxShadow(
            color: exam.color.withValues(alpha: 0.08),
            blurRadius: 20,
          ),
        ],
      ),
      child: Icon(
        exam.icon,
        color: exam.color,
        size: 42,
      ),
    );
  }

  Widget _buildInformation(_ExamData exam) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!widget.isMobile)
          Text(
            exam.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.w700,
            ),
          ),
        if (!widget.isMobile) const SizedBox(height: 10),
        Text(
          'Room: ${exam.room}',
          style: const TextStyle(
            color: Color(0xFF9CA3C7),
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 14,
          runSpacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _statusBadge(),
            _priorityBadge(exam.priority),
            Container(
              width: 1,
              height: 24,
              color: const Color(0xFF272D4D),
            ),
            _dateInformation(exam),
          ],
        ),
      ],
    );
  }

  Widget _statusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF32188A).withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(9),
      ),
      child: const Text(
        'Upcoming',
        style: TextStyle(
          color: Color(0xFFB79AFF),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _priorityBadge(String priority) {
    final bool high = priority == 'High';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: high
            ? const Color(0xFF541329).withValues(alpha: 0.55)
            : const Color(0xFF123B79).withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        priority,
        style: TextStyle(
          color: high
              ? const Color(0xFFFF465E)
              : const Color(0xFF67B6FF),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _dateInformation(_ExamData exam) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.calendar_today_outlined,
          color: Color(0xFFB4BBD6),
          size: 19,
        ),
        const SizedBox(width: 9),
        Text(
          '${exam.date} • ${exam.time}',
          style: const TextStyle(
            color: Color(0xFFB4BBD6),
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  Widget _buildCountdown(_ExamData exam) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 17,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF17130C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF674710),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.access_time_rounded,
            color: Color(0xFFFFAE00),
            size: 19,
          ),
          const SizedBox(width: 8),
          Text(
            exam.countdown,
            style: const TextStyle(
              color: Color(0xFFFFAE00),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteButton() {
    return IconButton(
      tooltip: 'Delete exam',
      onPressed: widget.onDelete,
      icon: const Icon(
        Icons.delete_outline_rounded,
        color: Color(0xFFFF4B61),
        size: 23,
      ),
      style: IconButton.styleFrom(
        backgroundColor: Colors.transparent,
        side: BorderSide(
          color: const Color(0xFFFF334F).withValues(alpha: 0.22),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

// ============================================================
// ADD EXAM DIALOG
// ============================================================

class _AddExamDialog extends StatefulWidget {
  const _AddExamDialog({
    required this.onAdd,
  });

  final ValueChanged<_ExamData> onAdd;

  @override
  State<_AddExamDialog> createState() => _AddExamDialogState();
}

class _AddExamDialogState extends State<_AddExamDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController =
      TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  String _priority = 'High';
  String _subject = 'Select subject';

  final List<String> _subjects = [
    'Select subject',
    'Data Structures',
    'Calculus II',
    'Web Development',
    'Database Systems',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
      initialDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF7C3AED),
              surface: Color(0xFF080D24),
            ),
          ),
          child: child!,
        );
      },
    );

    if (date == null) return;

    setState(() {
      _dateController.text =
          '${date.month.toString().padLeft(2, '0')}/'
          '${date.day.toString().padLeft(2, '0')}/'
          '${date.year}';
    });
  }

  void _submit() {
    final String title = _titleController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an exam title.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final String date = _dateController.text.trim().isEmpty
        ? 'May 12, 2024'
        : _dateController.text.trim();

    widget.onAdd(
      _ExamData(
        title: title,
        room: _subject == 'Select subject' ? 'TBD' : _subject,
        date: date,
        time: '10:00 AM',
        priority: _priority,
        color: const Color(0xFF8B5CF6),
        icon: Icons.description_outlined,
        countdown: 'Upcoming',
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final bool compact = width < 600;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: compact ? 18 : 24,
        vertical: 24,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 550,
        ),
        child: Container(
          padding: EdgeInsets.all(compact ? 22 : 30),
          decoration: BoxDecoration(
            color: const Color(0xFF080D24),
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: const Color(0xFF6535D9),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6D28D9).withValues(alpha: 0.16),
                blurRadius: 40,
                spreadRadius: 2,
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Add New Exam',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Color(0xFFB7BDD5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                _fieldLabel('Title'),
                const SizedBox(height: 8),
                _textField(
                  controller: _titleController,
                  hint: 'Enter exam title...',
                  icon: Icons.description_outlined,
                  autofocus: true,
                ),

                const SizedBox(height: 22),

                _fieldLabel('Description'),
                const SizedBox(height: 8),
                _textField(
                  controller: _descriptionController,
                  hint: 'Exam details...',
                  icon: Icons.description_outlined,
                  maxLines: 3,
                ),

                const SizedBox(height: 22),

                if (compact)
                  Column(
                    children: [
                      _buildDateField(),
                      const SizedBox(height: 18),
                      _buildPriorityField(),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateField(),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildPriorityField(),
                      ),
                    ],
                  ),

                const SizedBox(height: 22),

                _fieldLabel('Subject'),
                const SizedBox(height: 8),
                _buildSubjectField(),

                const SizedBox(height: 28),

                Align(
                  alignment: Alignment.centerRight,
                  child: _buildSubmitButton(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _textField({
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
        fontSize: 15,
      ),
      cursorColor: const Color(0xFF9B5CFF),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFF707895),
          fontSize: 14,
        ),
        prefixIcon: Icon(
          icon,
          color: const Color(0xFF9B5CFF),
          size: 20,
        ),
        filled: true,
        fillColor: const Color(0xFF060A1D),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(
            color: Color(0xFF252C4A),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(
            color: Color(0xFF8B3DFF),
            width: 1.3,
          ),
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel('Exam Date'),
        const SizedBox(height: 8),
        TextField(
          controller: _dateController,
          readOnly: true,
          onTap: _selectDate,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: 'mm/dd/yyyy, --:-- --',
            hintStyle: const TextStyle(
              color: Color(0xFF707895),
            ),
            prefixIcon: const Icon(
              Icons.calendar_today_outlined,
              color: Color(0xFF9B5CFF),
              size: 19,
            ),
            suffixIcon: const Icon(
              Icons.calendar_month_outlined,
              color: Color(0xFFB0B7D0),
              size: 19,
            ),
            filled: true,
            fillColor: const Color(0xFF060A1D),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(
                color: Color(0xFF252C4A),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(
                color: Color(0xFF8B3DFF),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriorityField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel('Priority'),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: _priority,
          dropdownColor: const Color(0xFF0B102A),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
          iconEnabledColor: const Color(0xFFB4BAD1),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.circle,
              color: _priority == 'High'
                  ? const Color(0xFFFF4058)
                  : const Color(0xFF4C9DFF),
              size: 11,
            ),
            filled: true,
            fillColor: const Color(0xFF060A1D),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(
                color: Color(0xFF252C4A),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(
                color: Color(0xFF8B3DFF),
              ),
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
            if (value == null) return;

            setState(() {
              _priority = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildSubjectField() {
    return DropdownButtonFormField<String>(
      initialValue: _subject,
      dropdownColor: const Color(0xFF0B102A),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
      iconEnabledColor: const Color(0xFFB4BAD1),
      decoration: InputDecoration(
        hintText: 'Select subject',
        hintStyle: const TextStyle(
          color: Color(0xFF707895),
        ),
        prefixIcon: const Icon(
          Icons.menu_book_outlined,
          color: Color(0xFF9B5CFF),
          size: 19,
        ),
        filled: true,
        fillColor: const Color(0xFF060A1D),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(
            color: Color(0xFF252C4A),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(
            color: Color(0xFF8B3DFF),
          ),
        ),
      ),
      items: _subjects
          .map(
            (subject) => DropdownMenuItem<String>(
              value: subject,
              child: Text(subject),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value == null) return;

        setState(() {
          _subject = value;
        });
      },
    );
  }

  Widget _buildSubmitButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _submit,
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 25),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF4924E8),
                Color(0xFF8B16E8),
              ],
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add Exam',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// EXAM MODEL
// ============================================================

class _ExamData {
  const _ExamData({
    required this.title,
    required this.room,
    required this.date,
    required this.time,
    required this.priority,
    required this.color,
    required this.icon,
    required this.countdown,
  });

  final String title;
  final String room;
  final String date;
  final String time;
  final String priority;
  final Color color;
  final IconData icon;
  final String countdown;
}