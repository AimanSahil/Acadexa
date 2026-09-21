import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/widgets/main_app_shell.dart';

class QuizzesPage extends StatefulWidget {
  const QuizzesPage({super.key});

  @override
  State<QuizzesPage> createState() => _QuizzesPageState();
}

class _QuizzesPageState extends State<QuizzesPage> {
  int _selectedTab = 0;

  final List<_QuizItem> _quizzes = [
    _QuizItem(
      title: 'Data Structures Fundamentals',
      questions: 7,
      subject: 'Data Structures',
    ),
  ];

  final List<_QuizResult> _results = [
    _QuizResult(
      title: 'Calculus Practice',
      score: 8,
      total: 10,
      date: 'Jul 28, 2024',
    ),
    _QuizResult(
      title: 'Web Development Basics',
      score: 9,
      total: 10,
      date: 'Jul 25, 2024',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MainAppShell(
      selectedRoute: '/quizzes',
      child: Container(
        color: const Color(0xFF020617),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isMobile = constraints.maxWidth < 700;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                isMobile ? 18 : 32,
                isMobile ? 20 : 28,
                isMobile ? 18 : 32,
                40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(isMobile),
                  const SizedBox(height: 30),
                  _buildTabs(),
                  const SizedBox(height: 30),
                  if (_selectedTab == 0)
                    _buildAvailableQuizzes(isMobile)
                  else
                    _buildResults(isMobile),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quizzes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.7,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Test your knowledge.',
                style: TextStyle(
                  color: Color(0xFFA4AABD),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        _PurpleButton(
          text: isMobile ? 'New' : 'New Quiz',
          icon: Icons.add_rounded,
          onTap: _showCreateQuizDialog,
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFF161D34),
          ),
        ),
      ),
      child: Row(
        children: [
          _QuizTab(
            title: 'Available (${_quizzes.length})',
            active: _selectedTab == 0,
            onTap: () {
              setState(() {
                _selectedTab = 0;
              });
            },
          ),
          const SizedBox(width: 4),
          _QuizTab(
            title: 'Results (${_results.length})',
            active: _selectedTab == 1,
            onTap: () {
              setState(() {
                _selectedTab = 1;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableQuizzes(bool isMobile) {
    if (_quizzes.isEmpty) {
      return _buildEmpty(
        icon: Icons.quiz_outlined,
        title: 'No quizzes available',
        subtitle: 'Create your first quiz to start learning.',
      );
    }

    return Column(
      children: [
        for (final quiz in _quizzes) ...[
          _QuizCard(
            quiz: quiz,
            onStart: () => _startQuiz(quiz),
            onDelete: () => _deleteQuiz(quiz),
          ),
          const SizedBox(height: 18),
        ],
      ],
    );
  }

  Widget _buildResults(bool isMobile) {
    if (_results.isEmpty) {
      return _buildEmpty(
        icon: Icons.assessment_outlined,
        title: 'No quiz results yet',
        subtitle: 'Complete a quiz and your result will appear here.',
      );
    }

    return Column(
      children: [
        for (final result in _results) ...[
          _ResultCard(result: result),
          const SizedBox(height: 18),
        ],
      ],
    );
  }

  Widget _buildEmpty({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 90),
      child: Column(
        children: [
          Icon(
            icon,
            color: const Color(0xFF7C3AED),
            size: 52,
          ),
          const SizedBox(height: 18),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFF858DA4),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _startQuiz(_QuizItem quiz) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _QuizAttemptPage(
          quiz: quiz,
          onCompleted: (result) {
            setState(() {
              _results.insert(0, result);
            });
          },
        ),
      ),
    );
  }

  void _deleteQuiz(_QuizItem quiz) {
    setState(() {
      _quizzes.remove(quiz);
    });

    _showMessage('Quiz deleted.');
  }

  void _showCreateQuizDialog() {
    final titleController = TextEditingController();
    final questionController =
        TextEditingController(text: '5');
    final topicController = TextEditingController();

    String subject = 'None';

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.78),
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
                  maxWidth: 560,
                ),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(
                    28,
                    24,
                    28,
                    25,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF080C20),
                    borderRadius: BorderRadius.circular(17),
                    border: Border.all(
                      color: const Color(0xFF30345A),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6D28D9)
                            .withValues(alpha: 0.12),
                        blurRadius: 40,
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
                                'Create Quiz',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 23,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.of(
                                  dialogContext,
                                ).pop();
                              },
                              icon: const Icon(
                                Icons.close_rounded,
                                color: Color(0xFFD3D8E7),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const _FieldLabel(
                          text: 'Quiz Title',
                        ),
                        const SizedBox(height: 8),
                        _QuizTextField(
                          controller: titleController,
                          hint: 'e.g. Midterm Statistics',
                          icon: Icons.list_alt_rounded,
                        ),
                        const SizedBox(height: 20),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth < 430) {
                              return Column(
                                children: [
                                  _QuizDropdown(
                                    label: 'Subject',
                                    value: subject,
                                    items: const [
                                      'None',
                                      'Data Structures',
                                      'Calculus',
                                      'Web Development',
                                    ],
                                    onChanged: (value) {
                                      setDialogState(() {
                                        subject = value;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 18),
                                  _QuizTextField(
                                    label: 'Questions',
                                    controller:
                                        questionController,
                                    hint: '5',
                                    icon:
                                        Icons.quiz_outlined,
                                    keyboardType:
                                        TextInputType.number,
                                  ),
                                ],
                              );
                            }

                            return Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: _QuizDropdown(
                                    label: 'Subject',
                                    value: subject,
                                    items: const [
                                      'None',
                                      'Data Structures',
                                      'Calculus',
                                      'Web Development',
                                    ],
                                    onChanged: (value) {
                                      setDialogState(() {
                                        subject = value;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: _QuizTextField(
                                    label: 'Questions',
                                    controller:
                                        questionController,
                                    hint: '5',
                                    icon:
                                        Icons.quiz_outlined,
                                    keyboardType:
                                        TextInputType.number,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        const _FieldLabel(
                          text: 'Topic (optional)',
                        ),
                        const SizedBox(height: 8),
                        _QuizTextField(
                          controller: topicController,
                          hint: 'e.g. Probability, Correlation...',
                          icon: Icons.sell_outlined,
                        ),
                        const SizedBox(height: 26),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(
                                  dialogContext,
                                ).pop();
                              },
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Color(0xFFD0D5E2),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            _PurpleButton(
                              text: 'Create & Start',
                              icon: Icons.play_arrow_rounded,
                              onTap: () {
                                final title =
                                    titleController.text.trim();

                                final count = int.tryParse(
                                      questionController.text
                                          .trim(),
                                    ) ??
                                    5;

                                if (title.isEmpty) {
                                  _showMessage(
                                    'Enter a quiz title.',
                                  );
                                  return;
                                }

                                if (count < 1) {
                                  _showMessage(
                                    'Questions must be at least 1.',
                                  );
                                  return;
                                }

                                final quiz = _QuizItem(
                                  title: title,
                                  questions: count,
                                  subject: subject,
                                );

                                setState(() {
                                  _quizzes.insert(0, quiz);
                                });

                                Navigator.of(
                                  dialogContext,
                                ).pop();

                                _startQuiz(quiz);
                              },
                            ),
                          ],
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

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF171B35),
        ),
      );
  }
}

class _QuizCard extends StatefulWidget {
  final _QuizItem quiz;
  final VoidCallback onStart;
  final VoidCallback onDelete;

  const _QuizCard({
    required this.quiz,
    required this.onStart,
    required this.onDelete,
  });

  @override
  State<_QuizCard> createState() => _QuizCardState();
}

class _QuizCardState extends State<_QuizCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
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
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: const Color(0xFF05091A),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: _hovering
                ? const Color(0xFF5632A8)
                : const Color(0xFF252A48),
          ),
          boxShadow: _hovering
              ? [
                  BoxShadow(
                    color: const Color(0xFF6D28D9)
                        .withValues(alpha: 0.08),
                    blurRadius: 25,
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 51,
                  height: 51,
                  decoration: BoxDecoration(
                    color: const Color(0xFF24105B),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.description_outlined,
                    color: Color(0xFFA56BFF),
                    size: 25,
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.quiz.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${widget.quiz.questions} questions',
                        style: const TextStyle(
                          color: Color(0xFFA0A8BA),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    color: Color(0xFF9DA5BA),
                  ),
                  color: const Color(0xFF11162B),
                  onSelected: (value) {
                    if (value == 'delete') {
                      widget.onDelete();
                    }
                  },
                  itemBuilder: (context) {
                    return const [
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_outline_rounded,
                              color: Color(0xFFFF5570),
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Delete',
                              style: TextStyle(
                                color: Color(0xFFFF5570),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ];
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              height: 1,
              color: const Color(0xFF202640),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onStart,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF4217D5),
                          Color(0xFF5B16D9),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.play_arrow_outlined,
                          color: Colors.white,
                          size: 22,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Start Quiz',
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final _QuizResult result;

  const _ResultCard({
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final double percentage =
        result.score / result.total;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF05091A),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFF252A48),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF091E19),
              border: Border.all(
                color: const Color(0xFF19C37D),
              ),
            ),
            child: Center(
              child: Text(
                '${(percentage * 100).round()}%',
                style: const TextStyle(
                  color: Color(0xFF25D994),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  result.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${result.score}/${result.total} correct • ${result.date}',
                  style: const TextStyle(
                    color: Color(0xFFA1A8BA),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuizAttemptPage extends StatefulWidget {
  final _QuizItem quiz;
  final ValueChanged<_QuizResult> onCompleted;

  const _QuizAttemptPage({
    required this.quiz,
    required this.onCompleted,
  });

  @override
  State<_QuizAttemptPage> createState() =>
      _QuizAttemptPageState();
}

class _QuizAttemptPageState extends State<_QuizAttemptPage> {
  late final List<_Question> _questions;

  final Map<int, int> _answers = {};

  int _currentIndex = 0;
  int _secondsRemaining = 30 * 60;

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _questions = _createQuestions(
      widget.quiz.questions,
    );

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (!mounted) return;

        if (_secondsRemaining <= 0) {
          _finishQuiz();
          return;
        }

        setState(() {
          _secondsRemaining--;
        });
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isMobile =
                constraints.maxWidth < 700;

            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 18 : 40,
                  vertical: 25,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 900,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      _buildTopBar(isMobile),
                      const SizedBox(height: 24),
                      _buildQuestionCard(
                        question,
                        isMobile,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopBar(bool isMobile) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          borderRadius: BorderRadius.circular(8),
          child: const Padding(
            padding: EdgeInsets.all(6),
            child: Row(
              children: [
                Icon(
                  Icons.arrow_back_rounded,
                  color: Color(0xFFCDD2DF),
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Exit',
                  style: TextStyle(
                    color: Color(0xFFD5D9E5),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
        Text(
          'Question ${_currentIndex + 1} of ${_questions.length}',
          style: const TextStyle(
            color: Color(0xFFDDE1EC),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Row(
          children: [
            const Icon(
              Icons.timer_outlined,
              color: Color(0xFFA56BFF),
              size: 19,
            ),
            const SizedBox(width: 6),
            Text(
              _formatTime(_secondsRemaining),
              style: const TextStyle(
                color: Color(0xFFA56BFF),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuestionCard(
    _Question question,
    bool isMobile,
  ) {
    final double progress =
        (_currentIndex + 1) / _questions.length;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(
        isMobile ? 20 : 26,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF070B1D),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFF303653),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Question ${_currentIndex + 1} of ${_questions.length}',
                  style: const TextStyle(
                    color: Color(0xFFE4E7F0),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                _formatTime(_secondsRemaining),
                style: const TextStyle(
                  color: Color(0xFFA56BFF),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: const Color(0xFF252B42),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(
                Color(0xFF7138E8),
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            question.question,
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 19 : 20,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 23),
          for (int i = 0;
              i < question.options.length;
              i++) ...[
            _AnswerOption(
              index: i,
              text: question.options[i],
              selected: _answers[_currentIndex] == i,
              onTap: () {
                setState(() {
                  _answers[_currentIndex] = i;
                });
              },
            ),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              OutlinedButton(
                onPressed: _currentIndex == 0
                    ? null
                    : () {
                        setState(() {
                          _currentIndex--;
                        });
                      },
                style: OutlinedButton.styleFrom(
                  foregroundColor:
                      const Color(0xFFB3B9C9),
                  side: const BorderSide(
                    color: Color(0xFF30364F),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(9),
                  ),
                ),
                child: const Text('Previous'),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _currentIndex ==
                        _questions.length - 1
                    ? _finishQuiz
                    : () {
                        setState(() {
                          _currentIndex++;
                        });
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF4C1DDA),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(9),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _currentIndex ==
                              _questions.length - 1
                          ? 'Finish'
                          : 'Next',
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      _currentIndex ==
                              _questions.length - 1
                          ? Icons.check_rounded
                          : Icons.arrow_forward_rounded,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _finishQuiz() {
    _timer?.cancel();

    int score = 0;

    for (int i = 0;
        i < _questions.length;
        i++) {
      if (_answers[i] == _questions[i].correctAnswer) {
        score++;
      }
    }

    final result = _QuizResult(
      title: widget.quiz.title,
      score: score,
      total: _questions.length,
      date: 'Today',
    );

    widget.onCompleted(result);

    Navigator.of(context).pop();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${remainingSeconds.toString().padLeft(2, '0')}';
  }

  List<_Question> _createQuestions(int count) {
    final questions = [
      const _Question(
        question: 'What is a fundamental concept in arrays?',
        options: [
          'Arrays in C are atomic',
          'Arrays store values of mixed data types',
          'Arrays do not have an index',
          'Arrays in C are indexed data structures',
        ],
        correctAnswer: 3,
      ),
      const _Question(
        question: 'Which data structure follows LIFO?',
        options: [
          'Queue',
          'Stack',
          'Linked List',
          'Graph',
        ],
        correctAnswer: 1,
      ),
      const _Question(
        question: 'What is the average time complexity of binary search?',
        options: [
          'O(n)',
          'O(log n)',
          'O(n²)',
          'O(1)',
        ],
        correctAnswer: 1,
      ),
      const _Question(
        question: 'Which structure follows FIFO?',
        options: [
          'Stack',
          'Tree',
          'Queue',
          'Heap',
        ],
        correctAnswer: 2,
      ),
      const _Question(
        question: 'Which is used to traverse a graph level by level?',
        options: [
          'DFS',
          'BFS',
          'Binary Search',
          'Quick Sort',
        ],
        correctAnswer: 1,
      ),
      const _Question(
        question: 'What is the root node in a tree?',
        options: [
          'The deepest node',
          'A leaf node',
          'The topmost node',
          'A child node',
        ],
        correctAnswer: 2,
      ),
      const _Question(
        question: 'Which algorithm is commonly used for shortest paths?',
        options: [
          'Dijkstra',
          'Bubble Sort',
          'Merge Sort',
          'DFS only',
        ],
        correctAnswer: 0,
      ),
    ];

    if (count <= questions.length) {
      return questions.take(count).toList();
    }

    final extra = <_Question>[];

    for (int i = questions.length; i < count; i++) {
      extra.add(
        _Question(
          question:
              'Practice question ${i + 1}: Which concept belongs to data structures?',
          options: const [
            'Arrays',
            'Typography',
            'Color theory',
            'Audio mixing',
          ],
          correctAnswer: 0,
        ),
      );
    }

    return [
      ...questions,
      ...extra,
    ];
  }
}

class _AnswerOption extends StatelessWidget {
  final int index;
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _AnswerOption({
    required this.index,
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final String letter =
        String.fromCharCode(65 + index);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 17,
          ),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFF181038)
                : const Color(0xFF060A1A),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected
                  ? const Color(0xFF8B4CFF)
                  : const Color(0xFF242B45),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 19,
                height: 19,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected
                        ? const Color(0xFF985CFF)
                        : const Color(0xFF66708B),
                    width: 1.5,
                  ),
                ),
                child: selected
                    ? Center(
                        child: Container(
                          width: 9,
                          height: 9,
                          decoration:
                              const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF985CFF),
                          ),
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 14),
              Text(
                '$letter.',
                style: const TextStyle(
                  color: Color(0xFFDDE1EB),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Color(0xFFD0D5E1),
                    fontSize: 14,
                    height: 1.4,
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

class _QuizTab extends StatelessWidget {
  final String title;
  final bool active;
  final VoidCallback onTap;

  const _QuizTab({
    required this.title,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 13,
          ),
          decoration: BoxDecoration(
            color: active
                ? const Color(0xFF160C3D)
                : Colors.transparent,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(9),
            ),
            border: Border(
              bottom: BorderSide(
                color: active
                    ? const Color(0xFF812BFF)
                    : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: active
                  ? const Color(0xFFB87AFF)
                  : const Color(0xFFC3C8D6),
              fontSize: 14,
              fontWeight:
                  active ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

class _QuizTextField extends StatelessWidget {
  final String? label;
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;

  const _QuizTextField({
    this.label,
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          _FieldLabel(text: label!),
          const SizedBox(height: 8),
        ],
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          cursorColor: const Color(0xFF955CFF),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFF747C92),
            ),
            prefixIcon: Icon(
              icon,
              color: const Color(0xFF8991A8),
              size: 20,
            ),
            filled: true,
            fillColor: const Color(0xFF060A1A),
            contentPadding:
                const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(
                color: Color(0xFF2A314C),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(
                color: Color(0xFF2A314C),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(
                color: Color(0xFF783AFF),
                width: 1.2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _QuizDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  const _QuizDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(text: label),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: value,
          dropdownColor: const Color(0xFF11162B),
          iconEnabledColor: const Color(0xFFAEB5C7),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF060A1A),
            contentPadding:
                const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(
                color: Color(0xFF2A314C),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(
                color: Color(0xFF2A314C),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(
                color: Color(0xFF783AFF),
              ),
            ),
          ),
          items: items
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                ),
              )
              .toList(),
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

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel({
    required this.text,
  });

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

class _PurpleButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const _PurpleButton({
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 13,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF4C19D9),
                Color(0xFF7020E8),
              ],
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6D28D9)
                    .withValues(alpha: 0.16),
                blurRadius: 18,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 19,
              ),
              const SizedBox(width: 7),
              Text(
                text,
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
    );
  }
}

class _QuizItem {
  final String title;
  final int questions;
  final String subject;

  const _QuizItem({
    required this.title,
    required this.questions,
    required this.subject,
  });
}

class _QuizResult {
  final String title;
  final int score;
  final int total;
  final String date;

  const _QuizResult({
    required this.title,
    required this.score,
    required this.total,
    required this.date,
  });
}

class _Question {
  final String question;
  final List<String> options;
  final int correctAnswer;

  const _Question({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });
}