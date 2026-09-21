import 'package:flutter/material.dart';

import '../../../../core/widgets/main_app_shell.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<_NoteItem> _notes = [
    _NoteItem(
      title: 'Binary Trees – Pre-Order DFS',
      content:
          'DFS (Depth-First Search) explores a node, then all its children from left to right before backtracking. Order: Root → Left → Right...',
      tags: ['Trees', 'Data Structures'],
      date: 'Jul 25, 2024',
    ),
    _NoteItem(
      title: 'Multivariate Chain Rule',
      content:
          'If z = f(u, v) and u = g(x, y), v = h(x, y), then: ∂z/∂x = (∂z/∂u)(∂u/∂x) + (∂z/∂v)(∂v/∂x)...',
      tags: ['Calculus', 'Mathematics'],
      date: 'Jul 20, 2024',
    ),
    _NoteItem(
      title: 'React: useId() Quick Reference',
      content:
          'useId() is a React hook that generates a unique ID on both the server and client. It’s useful for accessibility (labels, ARIA) and for consistent...',
      tags: ['React', 'Hooks'],
      date: 'Jul 10, 2024',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_NoteItem> get _filteredNotes {
    final query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      return _notes;
    }

    return _notes.where((note) {
      return note.title.toLowerCase().contains(query) ||
          note.content.toLowerCase().contains(query) ||
          note.tags.any(
            (tag) => tag.toLowerCase().contains(query),
          );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return MainAppShell(
      selectedRoute: '/notes',
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
                  const SizedBox(height: 30),
                  _buildSearchBar(),
                  const SizedBox(height: 30),
                  _buildNotesGrid(
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
                'Notes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 30 : 34,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                  letterSpacing: -0.7,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${_notes.length} notes saved',
                style: TextStyle(
                  color: const Color(0xFF9CA3B5),
                  fontSize: isMobile ? 15 : 17,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        _buildNewNoteButton(isMobile),
      ],
    );
  }

  Widget _buildNewNoteButton(bool isMobile) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: _showNewNoteDialog,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 14 : 20,
            vertical: isMobile ? 12 : 14,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF4F20E8),
                Color(0xFF7C22E8),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6D28D9).withValues(alpha: 0.20),
                blurRadius: 18,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 21,
              ),
              const SizedBox(width: 8),
              Text(
                'New Note',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 14 : 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: const Color(0xFF05091A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF1A2340),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (_) => setState(() {}),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        cursorColor: const Color(0xFF8B5CF6),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: Color(0xFF7F8AA6),
            size: 25,
          ),
          hintText: 'Search notes...',
          hintStyle: const TextStyle(
            color: Color(0xFF7F8AA6),
            fontSize: 16,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Color(0xFF7F8AA6),
                  ),
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 17,
            horizontal: 4,
          ),
        ),
      ),
    );
  }

  Widget _buildNotesGrid(
    double width,
    bool isMobile,
  ) {
    final notes = _filteredNotes;

    if (notes.isEmpty) {
      return _buildEmptySearchState();
    }

    if (width >= 1150) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: notes.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          childAspectRatio: 1.48,
        ),
        itemBuilder: (context, index) {
          return _NoteCard(
            note: notes[index],
            onDelete: () => _deleteNote(notes[index]),
          );
        },
      );
    }

    if (width >= 700) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: notes.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 1.35,
        ),
        itemBuilder: (context, index) {
          return _NoteCard(
            note: notes[index],
            onDelete: () => _deleteNote(notes[index]),
          );
        },
      );
    }

    return Column(
      children: [
        for (int index = 0; index < notes.length; index++) ...[
          _NoteCard(
            note: notes[index],
            onDelete: () => _deleteNote(notes[index]),
          ),
          if (index != notes.length - 1)
            const SizedBox(height: 18),
        ],
      ],
    );
  }

  Widget _buildEmptySearchState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 80,
        horizontal: 20,
      ),
      child: Column(
        children: [
          Container(
            width: 82,
            height: 82,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF11152C),
              border: Border.all(
                color: const Color(0xFF2B1B61),
              ),
            ),
            child: const Icon(
              Icons.search_off_rounded,
              color: Color(0xFF8B5CF6),
              size: 38,
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'No notes found',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try searching with a different keyword.',
            style: TextStyle(
              color: Color(0xFF8D96AE),
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  void _showNewNoteDialog() {
    final titleController = TextEditingController();
    final tagsController = TextEditingController();
    final contentController = TextEditingController();

    String selectedSubject = 'None';

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
                  maxWidth: 570,
                ),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(
                    28,
                    25,
                    28,
                    26,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF080C22),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: const Color(0xFF30305D),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF5B21B6)
                            .withValues(alpha: 0.10),
                        blurRadius: 35,
                        spreadRadius: 2,
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
                                'New Note',
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
                                color: Color(0xFFD5D9E7),
                                size: 23,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const _FieldLabel(
                          label: 'Title',
                        ),
                        const SizedBox(height: 8),
                        _DarkTextField(
                          controller: titleController,
                          hintText: 'Enter title...',
                          icon: Icons.menu_book_rounded,
                          autofocus: true,
                        ),
                        const SizedBox(height: 22),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth < 430) {
                              return Column(
                                children: [
                                  _SubjectField(
                                    value: selectedSubject,
                                    onChanged: (value) {
                                      setDialogState(() {
                                        selectedSubject = value;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 18),
                                  _TagsField(
                                    controller: tagsController,
                                  ),
                                ],
                              );
                            }

                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: _SubjectField(
                                    value: selectedSubject,
                                    onChanged: (value) {
                                      setDialogState(() {
                                        selectedSubject = value;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 18),
                                Expanded(
                                  child: _TagsField(
                                    controller: tagsController,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 22),
                        const _FieldLabel(
                          label: 'Content',
                        ),
                        const SizedBox(height: 8),
                        _DarkTextField(
                          controller: contentController,
                          hintText: 'Write your note here...',
                          maxLines: 6,
                          minLines: 5,
                          icon: Icons.description_outlined,
                          alignIconTop: true,
                        ),
                        const SizedBox(height: 22),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                              },
                              style: TextButton.styleFrom(
                                foregroundColor:
                                    const Color(0xFFD0D4E4),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 14,
                                ),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            _GradientButton(
                              label: 'Create Note',
                              icon: Icons.add_rounded,
                              onPressed: () {
                                final title =
                                    titleController.text.trim();
                                final content =
                                    contentController.text.trim();

                                if (title.isEmpty) {
                                  _showMessage(
                                    'Please enter a note title.',
                                  );
                                  return;
                                }

                                setState(() {
                                  _notes.insert(
                                    0,
                                    _NoteItem(
                                      title: title,
                                      content: content.isEmpty
                                          ? 'No content added yet.'
                                          : content,
                                      tags: tagsController.text
                                          .split(',')
                                          .map(
                                            (tag) => tag.trim(),
                                          )
                                          .where(
                                            (tag) => tag.isNotEmpty,
                                          )
                                          .toList(),
                                      date: 'Today',
                                    ),
                                  );
                                });

                                Navigator.of(dialogContext).pop();

                                _showMessage(
                                  'Note created successfully.',
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

  void _deleteNote(_NoteItem note) {
    setState(() {
      _notes.remove(note);
    });

    _showMessage('Note deleted.');
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
  }
}

class _NoteCard extends StatefulWidget {
  final _NoteItem note;
  final VoidCallback onDelete;

  const _NoteCard({
    required this.note,
    required this.onDelete,
  });

  @override
  State<_NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<_NoteCard> {
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
          22,
          21,
          18,
          19,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF05091A),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: _hovering
                ? const Color(0xFF6736C8)
                : const Color(0xFF1B2440),
            width: 1,
          ),
          boxShadow: _hovering
              ? [
                  BoxShadow(
                    color: const Color(0xFF6D28D9)
                        .withValues(alpha: 0.08),
                    blurRadius: 25,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    widget.note.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _buildMenu(),
              ],
            ),
            const SizedBox(height: 14),
            Expanded(
              child: Text(
                widget.note.content,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF9DA5BA),
                  fontSize: 14,
                  height: 1.65,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 7,
              children: widget.note.tags.map(_buildTag).toList(),
            ),
            const SizedBox(height: 14),
            Text(
              widget.note.date,
              style: const TextStyle(
                color: Color(0xFF8D96AC),
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenu() {
    return PopupMenuButton<String>(
      tooltip: 'More',
      padding: EdgeInsets.zero,
      icon: const Icon(
        Icons.more_vert_rounded,
        color: Color(0xFF8E97AE),
        size: 22,
      ),
      color: const Color(0xFF11162B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(
          color: Color(0xFF292F4D),
        ),
      ),
      onSelected: (value) {
        if (value == 'delete') {
          widget.onDelete();
        }

        if (value == 'edit') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Edit note will be available here.',
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      itemBuilder: (context) {
        return const [
          PopupMenuItem(
            value: 'edit',
            child: Row(
              children: [
                Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: Color(0xFFD4D8E6),
                ),
                SizedBox(width: 10),
                Text(
                  'Edit',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Icon(
                  Icons.delete_outline_rounded,
                  size: 18,
                  color: Color(0xFFFF5570),
                ),
                SizedBox(width: 10),
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
    );
  }

  Widget _buildTag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF171145),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF28205F),
        ),
      ),
      child: Text(
        tag,
        style: const TextStyle(
          color: Color(0xFFC6B5FF),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _DarkTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final int? maxLines;
  final int? minLines;
  final bool autofocus;
  final bool alignIconTop;

  const _DarkTextField({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.maxLines = 1,
    this.minLines,
    this.autofocus = false,
    this.alignIconTop = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: autofocus,
      minLines: minLines,
      maxLines: maxLines,
      cursorColor: const Color(0xFF9B5CFF),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFF737C96),
          fontSize: 14,
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.only(
            top: alignIconTop ? 15 : 0,
          ),
          child: Icon(
            icon,
            color: const Color(0xFF8F83B9),
            size: 19,
          ),
        ),
        filled: true,
        fillColor: const Color(0xFF070B1E),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(
            color: Color(0xFF242C49),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(
            color: Color(0xFF813BFF),
            width: 1.3,
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;

  const _FieldLabel({
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _SubjectField extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const _SubjectField({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel(
          label: 'Subject (optional)',
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: value,
          dropdownColor: const Color(0xFF10152B),
          iconEnabledColor: const Color(0xFFB7BED1),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
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
                color: Color(0xFF242C49),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(
                color: Color(0xFF242C49),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(
                color: Color(0xFF813BFF),
              ),
            ),
          ),
          items: const [
            DropdownMenuItem(
              value: 'None',
              child: Text('None'),
            ),
            DropdownMenuItem(
              value: 'Data Structures',
              child: Text('Data Structures'),
            ),
            DropdownMenuItem(
              value: 'Calculus II',
              child: Text('Calculus II'),
            ),
            DropdownMenuItem(
              value: 'Web Development',
              child: Text('Web Development'),
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

class _TagsField extends StatelessWidget {
  final TextEditingController controller;

  const _TagsField({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel(
          label: 'Tags (comma separated)',
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          cursorColor: const Color(0xFF9B5CFF),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: 'e.g. chapter1, important',
            hintStyle: const TextStyle(
              color: Color(0xFF737C96),
              fontSize: 13,
            ),
            filled: true,
            fillColor: const Color(0xFF070B1E),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 15,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(
                color: Color(0xFF242C49),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(
                color: Color(0xFF242C49),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(
                color: Color(0xFF813BFF),
                width: 1.3,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _GradientButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _GradientButton({
    required this.label,
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
                Color(0xFF7C22E8),
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
                label,
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

class _NoteItem {
  final String title;
  final String content;
  final List<String> tags;
  final String date;

  const _NoteItem({
    required this.title,
    required this.content,
    required this.tags,
    required this.date,
  });
}