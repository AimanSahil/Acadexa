import 'package:flutter/material.dart';

import '../../../../core/widgets/main_app_shell.dart';

class FlashcardsPage extends StatefulWidget {
  const FlashcardsPage({super.key});

  @override
  State<FlashcardsPage> createState() => _FlashcardsPageState();
}

class _FlashcardsPageState extends State<FlashcardsPage> {
  final List<_FlashcardItem> _cards = [
    _FlashcardItem(
      question: 'What is the time complexity of binary search?',
      answer: 'O(log n) – It divides the search space in half each step.',
      subject: 'Data Structures',
      difficulty: 'Easy',
    ),
    _FlashcardItem(
      question: 'What is a stack data structure?',
      answer:
          'A linear data structure that follows LIFO (Last In First Out) principle. Elements are added and removed from the same end, called the top.',
      subject: 'Data Structures',
      difficulty: 'Medium',
    ),
    _FlashcardItem(
      question: 'What does PR in React stand for?',
      answer:
          'PR stands for "Pull Request", used to propose changes to a codebase.',
      subject: 'Web Development',
      difficulty: 'Medium',
    ),
    _FlashcardItem(
      question: 'What does ∇f (gradient) represent?',
      answer:
          'The vector of partial derivatives, pointing in the direction of steepest ascent.',
      subject: 'Calculus',
      difficulty: 'Medium',
    ),
    _FlashcardItem(
      question: 'What is the derivative of x²?',
      answer: 'The derivative of x² is 2x.',
      subject: 'Calculus',
      difficulty: 'Easy',
    ),
    _FlashcardItem(
      question: 'What is a binary tree?',
      answer:
          'A tree data structure where each node has at most two children.',
      subject: 'Data Structures',
      difficulty: 'Easy',
    ),
  ];

  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return MainAppShell(
      selectedRoute: '/flashcards',
      child: Container(
        color: const Color(0xFF020617),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isMobile = constraints.maxWidth < 700;
            final bool isTablet = constraints.maxWidth < 1100;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                isMobile
                    ? 18
                    : isTablet
                        ? 28
                        : 36,
                isMobile ? 22 : 30,
                isMobile
                    ? 18
                    : isTablet
                        ? 28
                        : 36,
                40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(isMobile),
                  const SizedBox(height: 28),
                  _buildFilters(isMobile),
                  const SizedBox(height: 28),
                  _buildCardsGrid(
                    constraints.maxWidth,
                    isMobile,
                  ),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Flashcards',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 30 : 34,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                'Review and master key concepts.',
                style: TextStyle(
                  color: const Color(0xFFA0A8BB),
                  fontSize: isMobile ? 15 : 17,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 15),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStudyModeButton(isMobile),
            const SizedBox(width: 12),
            _buildAddButton(isMobile),
          ],
        ),
      ],
    );
  }

  Widget _buildStudyModeButton(bool isMobile) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(11),
        onTap: _openStudyMode,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 12 : 17,
            vertical: isMobile ? 11 : 13,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF05091A),
            borderRadius: BorderRadius.circular(11),
            border: Border.all(
              color: const Color(0xFF2A3150),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.menu_book_outlined,
                color: Colors.white,
                size: 20,
              ),
              if (!isMobile) ...[
                const SizedBox(width: 9),
                const Text(
                  'Study Mode',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton(bool isMobile) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(11),
        onTap: _showAddCardDialog,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 12 : 18,
            vertical: isMobile ? 11 : 13,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF4F20E8),
                Color(0xFF7920E8),
              ],
            ),
            borderRadius: BorderRadius.circular(11),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6D28D9)
                    .withValues(alpha: 0.18),
                blurRadius: 18,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 20,
              ),
              if (!isMobile) ...[
                const SizedBox(width: 8),
                const Text(
                  'Add Card',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilters(bool isMobile) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterChip(
            label: 'All (32)',
            active: _selectedFilter == 'All',
            color: const Color(0xFF7C3AED),
            onTap: () {
              setState(() {
                _selectedFilter = 'All';
              });
            },
          ),
          const SizedBox(width: 16),
          _FilterChip(
            label: 'Data Structures (12)',
            active: _selectedFilter == 'Data Structures',
            color: const Color(0xFF9B6BFF),
            onTap: () {
              setState(() {
                _selectedFilter = 'Data Structures';
              });
            },
          ),
          const SizedBox(width: 16),
          _FilterChip(
            label: 'Calculus (6)',
            active: _selectedFilter == 'Calculus',
            color: const Color(0xFFFF5570),
            onTap: () {
              setState(() {
                _selectedFilter = 'Calculus';
              });
            },
          ),
          const SizedBox(width: 16),
          _FilterChip(
            label: 'Web Development (14)',
            active: _selectedFilter == 'Web Development',
            color: const Color(0xFF20C979),
            onTap: () {
              setState(() {
                _selectedFilter = 'Web Development';
              });
            },
          ),
        ],
      ),
    );
  }

  List<_FlashcardItem> get _filteredCards {
    if (_selectedFilter == 'All') {
      return _cards;
    }

    return _cards
        .where(
          (card) => card.subject == _selectedFilter,
        )
        .toList();
  }

  Widget _buildCardsGrid(
    double width,
    bool isMobile,
  ) {
    final cards = _filteredCards;

    if (cards.isEmpty) {
      return _buildEmptyState();
    }

    if (width >= 1150) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: cards.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          childAspectRatio: 1.30,
        ),
        itemBuilder: (context, index) {
          return _FlashcardCard(
            card: cards[index],
            onDelete: () => _deleteCard(cards[index]),
          );
        },
      );
    }

    if (width >= 700) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: cards.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 1.30,
        ),
        itemBuilder: (context, index) {
          return _FlashcardCard(
            card: cards[index],
            onDelete: () => _deleteCard(cards[index]),
          );
        },
      );
    }

    return Column(
      children: [
        for (int index = 0; index < cards.length; index++) ...[
          _FlashcardCard(
            card: cards[index],
            onDelete: () => _deleteCard(cards[index]),
          ),
          if (index != cards.length - 1)
            const SizedBox(height: 18),
        ],
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Column(
        children: [
          Container(
            width: 85,
            height: 85,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF0D1027),
              border: Border.all(
                color: const Color(0xFF30215F),
              ),
            ),
            child: const Icon(
              Icons.style_outlined,
              color: Color(0xFF8B5CF6),
              size: 40,
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'No flashcards found',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _deleteCard(_FlashcardItem card) {
    setState(() {
      _cards.remove(card);
    });

    _showMessage('Flashcard deleted.');
  }

  void _openStudyMode() {
    if (_cards.isEmpty) {
      _showMessage('Add a flashcard before starting study mode.');
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _StudyModePage(
          cards: List<_FlashcardItem>.from(_filteredCards),
        ),
      ),
    );
  }

  void _showAddCardDialog() {
    final questionController = TextEditingController();
    final answerController = TextEditingController();

    String selectedSubject = 'None';
    String selectedDifficulty = 'Medium';

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
                    color: const Color(0xFF070B1D),
                    borderRadius: BorderRadius.circular(17),
                    border: Border.all(
                      color: const Color(0xFF30305D),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6D28D9)
                            .withValues(alpha: 0.10),
                        blurRadius: 35,
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Add Flashcard',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 23,
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
                                color: Color(0xFFD4D8E6),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        const _FormLabel(
                          text: 'Question',
                        ),
                        const SizedBox(height: 8),
                        _FlashcardTextField(
                          controller: questionController,
                          hint: 'Enter question...',
                          maxLines: 4,
                        ),
                        const SizedBox(height: 20),
                        const _FormLabel(
                          text: 'Answer',
                        ),
                        const SizedBox(height: 8),
                        _FlashcardTextField(
                          controller: answerController,
                          hint: 'Enter answer...',
                          maxLines: 4,
                        ),
                        const SizedBox(height: 20),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth < 430) {
                              return Column(
                                children: [
                                  _DropdownField(
                                    label: 'Subject',
                                    value: selectedSubject,
                                    items: const [
                                      'None',
                                      'Data Structures',
                                      'Calculus',
                                      'Web Development',
                                    ],
                                    onChanged: (value) {
                                      setDialogState(() {
                                        selectedSubject = value;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 18),
                                  _DropdownField(
                                    label: 'Difficulty',
                                    value: selectedDifficulty,
                                    items: const [
                                      'Easy',
                                      'Medium',
                                      'Hard',
                                    ],
                                    onChanged: (value) {
                                      setDialogState(() {
                                        selectedDifficulty = value;
                                      });
                                    },
                                  ),
                                ],
                              );
                            }

                            return Row(
                              children: [
                                Expanded(
                                  child: _DropdownField(
                                    label: 'Subject',
                                    value: selectedSubject,
                                    items: const [
                                      'None',
                                      'Data Structures',
                                      'Calculus',
                                      'Web Development',
                                    ],
                                    onChanged: (value) {
                                      setDialogState(() {
                                        selectedSubject = value;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 18),
                                Expanded(
                                  child: _DropdownField(
                                    label: 'Difficulty',
                                    value: selectedDifficulty,
                                    items: const [
                                      'Easy',
                                      'Medium',
                                      'Hard',
                                    ],
                                    onChanged: (value) {
                                      setDialogState(() {
                                        selectedDifficulty = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                              },
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Color(0xFFD0D5E3),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            _PurpleButton(
                              text: 'Add Flashcard',
                              icon: Icons.add_rounded,
                              onPressed: () {
                                final question =
                                    questionController.text.trim();
                                final answer =
                                    answerController.text.trim();

                                if (question.isEmpty ||
                                    answer.isEmpty) {
                                  _showMessage(
                                    'Question and answer are required.',
                                  );
                                  return;
                                }

                                setState(() {
                                  _cards.insert(
                                    0,
                                    _FlashcardItem(
                                      question: question,
                                      answer: answer,
                                      subject: selectedSubject,
                                      difficulty:
                                          selectedDifficulty,
                                    ),
                                  );
                                });

                                Navigator.of(dialogContext).pop();

                                _showMessage(
                                  'Flashcard added successfully.',
                                );
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

class _FlashcardCard extends StatefulWidget {
  final _FlashcardItem card;
  final VoidCallback onDelete;

  const _FlashcardCard({
    required this.card,
    required this.onDelete,
  });

  @override
  State<_FlashcardCard> createState() => _FlashcardCardState();
}

class _FlashcardCardState extends State<_FlashcardCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
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
        padding: const EdgeInsets.fromLTRB(
          26,
          23,
          24,
          22,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF030717),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: _hovering
                ? const Color(0xFF5533A5)
                : const Color(0xFF1D2742),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Q',
                  style: TextStyle(
                    color: Color(0xFFA56BFF),
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    color: Color(0xFF9AA3B8),
                    size: 21,
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
                            SizedBox(width: 9),
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
            const SizedBox(height: 14),
            Text(
              widget.card.question,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                height: 1.45,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 17),
            Container(
              height: 1,
              color: const Color(0xFF202A43),
            ),
            const SizedBox(height: 20),
            const Text(
              'A',
              style: TextStyle(
                color: Color(0xFFA56BFF),
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 9),
            Expanded(
              child: Text(
                widget.card.answer,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFFA9B0C2),
                  fontSize: 15,
                  height: 1.55,
                ),
              ),
            ),
            const SizedBox(height: 15),
            _DifficultyBadge(
              difficulty: widget.card.difficulty,
            ),
          ],
        ),
      ),
    );
  }
}

class _DifficultyBadge extends StatelessWidget {
  final String difficulty;

  const _DifficultyBadge({
    required this.difficulty,
  });

  @override
  Widget build(BuildContext context) {
    Color border;
    Color text;

    switch (difficulty) {
      case 'Easy':
        border = const Color(0xFF00C878);
        text = const Color(0xFF20E68C);
        break;
      case 'Hard':
        border = const Color(0xFFFF375F);
        text = const Color(0xFFFF5570);
        break;
      default:
        border = const Color(0xFFE6A700);
        text = const Color(0xFFFFC107);
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: text.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: border,
        ),
      ),
      child: Text(
        difficulty,
        style: TextStyle(
          color: text,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool active;
  final Color color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.active,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: active
                ? const Color(0xFF4218C9)
                : const Color(0xFF030717),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: active
                  ? const Color(0xFF733DFF)
                  : color.withValues(alpha: 0.65),
            ),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: const Color(0xFF6D28D9)
                          .withValues(alpha: 0.18),
                      blurRadius: 14,
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: active ? Colors.white : color,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _StudyModePage extends StatefulWidget {
  final List<_FlashcardItem> cards;

  const _StudyModePage({
    required this.cards,
  });

  @override
  State<_StudyModePage> createState() => _StudyModePageState();
}

class _StudyModePageState extends State<_StudyModePage> {
  int _currentIndex = 0;
  bool _showAnswer = false;

  @override
  Widget build(BuildContext context) {
    final card = widget.cards[_currentIndex];
    final progress = (_currentIndex + 1) / widget.cards.length;

    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isMobile = constraints.maxWidth < 700;

            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 20 : 50,
                  vertical: 30,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 900,
                  ),
                  child: Column(
                    children: [
                      _buildStudyHeader(
                        card,
                        isMobile,
                      ),
                      SizedBox(
                        height: isMobile ? 35 : 48,
                      ),
                      _buildStudyCard(
                        card,
                        isMobile,
                      ),
                      SizedBox(
                        height: isMobile ? 24 : 36,
                      ),
                      _buildStudyActions(
                        isMobile,
                      ),
                      const SizedBox(height: 28),
                      _buildProgress(progress),
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

  Widget _buildStudyHeader(
    _FlashcardItem card,
    bool isMobile,
  ) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          borderRadius: BorderRadius.circular(8),
          child: const Padding(
            padding: EdgeInsets.all(5),
            child: Row(
              children: [
                Icon(
                  Icons.arrow_back_rounded,
                  color: Color(0xFFCBD1DF),
                  size: 21,
                ),
                SizedBox(width: 8),
                Text(
                  'Exit',
                  style: TextStyle(
                    color: Color(0xFFD6DAE6),
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
        Text(
          '${_currentIndex + 1} / ${widget.cards.length}',
          style: const TextStyle(
            color: Color(0xFFE4E7F0),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        _DifficultyBadge(
          difficulty: card.difficulty,
        ),
      ],
    );
  }

  Widget _buildStudyCard(
    _FlashcardItem card,
    bool isMobile,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showAnswer = !_showAnswer;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: double.infinity,
        constraints: BoxConstraints(
          minHeight: isMobile ? 340 : 340,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 24 : 55,
          vertical: isMobile ? 45 : 60,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF11132E),
              Color(0xFF080B20),
            ],
          ),
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: const Color(0xFF6138B9),
            width: 1.1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF5B21B6)
                  .withValues(alpha: 0.10),
              blurRadius: 35,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'QUESTION',
              style: TextStyle(
                color: Color(0xFFA66BFF),
                fontSize: 15,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 25),
            Text(
              card.question,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: isMobile ? 22 : 27,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 30),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _showAnswer
                  ? Column(
                      key: const ValueKey('answer'),
                      children: [
                        Container(
                          height: 1,
                          width: 100,
                          color: const Color(0xFF34375B),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          card.answer,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFFC4CAD9),
                            fontSize: isMobile ? 16 : 18,
                            height: 1.6,
                          ),
                        ),
                      ],
                    )
                  : const Row(
                      key: ValueKey('hidden'),
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.visibility_off_outlined,
                          color: Color(0xFF9BA3B8),
                          size: 21,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Tap to reveal answer',
                          style: TextStyle(
                            color: Color(0xFFA3AABE),
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudyActions(bool isMobile) {
    return Row(
      children: [
        Expanded(
          child: _StudyActionButton(
            label: 'Still Learning',
            icon: Icons.close_rounded,
            color: const Color(0xFFFF3D57),
            background: const Color(0xFF1A0710),
            onTap: _stillLearning,
          ),
        ),
        const SizedBox(width: 22),
        Expanded(
          child: _StudyActionButton(
            label: 'Got It',
            icon: Icons.check_rounded,
            color: const Color(0xFF21E695),
            background: const Color(0xFF06271C),
            onTap: _gotIt,
          ),
        ),
      ],
    );
  }

  Widget _buildProgress(double progress) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.cards.length,
        (index) {
          final bool active = index == _currentIndex;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            margin: const EdgeInsets.symmetric(horizontal: 5),
            width: active ? 42 : 32,
            height: 6,
            decoration: BoxDecoration(
              color: active
                  ? const Color(0xFF955CFF)
                  : const Color(0xFF20253A),
              borderRadius: BorderRadius.circular(10),
            ),
          );
        },
      ),
    );
  }

  void _stillLearning() {
    _nextCard();
  }

  void _gotIt() {
    _nextCard();
  }

  void _nextCard() {
    if (_currentIndex >= widget.cards.length - 1) {
      _showFinishedDialog();
      return;
    }

    setState(() {
      _currentIndex++;
      _showAnswer = false;
    });
  }

  void _showFinishedDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0A0E23),
          title: const Text(
            'Study session complete',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: const Text(
            'You reached the end of this flashcard session.',
            style: TextStyle(
              color: Color(0xFFAEB5C8),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Continue',
                style: TextStyle(
                  color: Color(0xFFA66BFF),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _StudyActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Color background;
  final VoidCallback onTap;

  const _StudyActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.background,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Container(
          height: 62,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: color.withValues(alpha: 0.75),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: color,
                size: 22,
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 16,
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

class _FormLabel extends StatelessWidget {
  final String text;

  const _FormLabel({
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

class _FlashcardTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;

  const _FlashcardTextField({
    required this.controller,
    required this.hint,
    required this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      minLines: 3,
      cursorColor: const Color(0xFF9B5CFF),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFF737C96),
        ),
        filled: true,
        fillColor: const Color(0xFF070B1E),
        contentPadding: const EdgeInsets.all(15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(
            color: Color(0xFF252C48),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(
            color: Color(0xFF252C48),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(
            color: Color(0xFF813BFF),
            width: 1.2,
          ),
        ),
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  const _DropdownField({
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
        _FormLabel(text: label),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: value,
          dropdownColor: const Color(0xFF11162B),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
          iconEnabledColor: const Color(0xFFB7BED1),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF070B1E),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(
                color: Color(0xFF252C48),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(
                color: Color(0xFF252C48),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(
                color: Color(0xFF813BFF),
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

class _PurpleButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  const _PurpleButton({
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(9),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 13,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF4F20E8),
                Color(0xFF7920E8),
              ],
            ),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 18,
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

class _FlashcardItem {
  final String question;
  final String answer;
  final String subject;
  final String difficulty;

  const _FlashcardItem({
    required this.question,
    required this.answer,
    required this.subject,
    required this.difficulty,
  });
}