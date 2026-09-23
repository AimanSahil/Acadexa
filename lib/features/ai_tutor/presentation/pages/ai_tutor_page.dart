import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';

import '../../../../core/widgets/main_app_shell.dart';
import '../../data/services/google_drive_service.dart';
import '../widgets/google_drive_picker.dart';

class AiTutorPage extends StatefulWidget {
  const AiTutorPage({super.key});

  @override
  State<AiTutorPage> createState() => _AiTutorPageState();
}

class _AiTutorPageState extends State<AiTutorPage> {
  final TextEditingController _sessionController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();

  final AudioRecorder _audioRecorder = AudioRecorder();
  final GoogleDriveService _googleDriveService =
    GoogleDriveService();

  final List<_TutorSession> _sessions = [
    _TutorSession(
      title: 'Study Helper Algorithms',
      messages: 3,
    ),
  ];

  int? _selectedSessionIndex;

  final List<PlatformFile> _attachedFiles = [];

  bool _showAttachmentMenu = false;
  bool _showMoreUploads = false;
  bool _showMoreTools = false;
  bool _isRecording = false;

  final List<_ChatMessage> _messages = [];

  @override
  void dispose() {
    _sessionController.dispose();
    _messageController.dispose();
    _messageFocusNode.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainAppShell(
      selectedRoute: '/ai-tutor',
      child: Container(
        color: const Color(0xFF020617),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isMobile = constraints.maxWidth < 850;

            if (isMobile) {
              return _buildMobileLayout();
            }

            return _buildDesktopLayout();
          },
        ),
      ),
    );
  }

  // ============================================================
  // DESKTOP
  // ============================================================

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        SizedBox(
          width: 310,
          child: _buildTutorSidebar(),
        ),
        Expanded(
          child: _buildConversationArea(),
        ),
      ],
    );
  }

  // ============================================================
  // MOBILE
  // ============================================================

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildMobileHeader(),
        Expanded(
          child: _buildConversationArea(),
        ),
      ],
    );
  }

  Widget _buildMobileHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFF1E293B),
          ),
        ),
      ),
      child: Row(
        children: [
          _buildRobotIcon(size: 42),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Tutor ✦',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Your personal study assistant',
                  style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _startNewChat,
            icon: const Icon(
              Icons.add_comment_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // AI TUTOR SIDEBAR
  // ============================================================

  Widget _buildTutorSidebar() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF020617),
        border: Border(
          right: BorderSide(
            color: Color(0xFF1E293B),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTutorHeader(),

          const SizedBox(height: 24),

          _buildSessionNameField(),

          const SizedBox(height: 14),

          _buildNewChatButton(),

          const SizedBox(height: 18),

          const Divider(
            color: Color(0xFF1E293B),
            height: 1,
          ),

          const SizedBox(height: 24),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Recent Conversations',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 14),

          Expanded(
            child: _sessions.isEmpty
                ? _buildNoSessions()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: _sessions.length,
                    itemBuilder: (context, index) {
                      return _buildSessionItem(
                        _sessions[index],
                        index,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTutorHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 28, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'AI Tutor',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: 8),
              Text(
                '✦',
                style: TextStyle(
                  color: Color(0xFFD946EF),
                  fontSize: 24,
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Text(
            'Your personal study assistant',
            style: TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionNameField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: _sessionController,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: 'Enter session name (optional)',
          hintStyle: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 14,
          ),
          filled: true,
          fillColor: const Color(0xFF080D20),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 15,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Color(0xFF334155),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Color(0xFF7C3AED),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNewChatButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton.icon(
          onPressed: _startNewChat,
          icon: const Icon(
            Icons.chat_bubble_outline,
            size: 20,
          ),
          label: const Text(
            'New Chat',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4F16D8),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoSessions() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'No conversations yet.\nStart a new chat.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF64748B),
            fontSize: 13,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildSessionItem(
    _TutorSession session,
    int index,
  ) {
    final bool selected = _selectedSessionIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSessionIndex = index;
          _showAttachmentMenu = false;
          _showMoreUploads = false;
          _showMoreTools = false;
        });

        _loadSession(index);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 11,
        ),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF21104C)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: selected
              ? Border.all(
                  color: const Color(0xFF6D28D9),
                )
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF4C1D95)
                    : const Color(0xFF111827),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(
                Icons.smart_toy_outlined,
                color: selected
                    ? const Color(0xFFD8B4FE)
                    : const Color(0xFF94A3B8),
                size: 20,
              ),
            ),

            const SizedBox(width: 11),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${session.messages} messages',
                    style: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

            PopupMenuButton<String>(
              tooltip: 'Conversation options',
              color: const Color(0xFF0F172A),
              icon: const Icon(
                Icons.more_vert,
                color: Color(0xFF94A3B8),
                size: 19,
              ),
              onSelected: (value) {
                if (value == 'delete') {
                  _deleteSession(index);
                }
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent,
                          size: 18,
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
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CONVERSATION AREA
  // ============================================================

  Widget _buildConversationArea() {
    final bool hasConversation = _selectedSessionIndex != null;

    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: hasConversation
                  ? _buildChatMessages()
                  : _buildEmptyConversation(),
            ),

            _buildChatComposer(),
          ],
        ),

        if (_showAttachmentMenu)
          _buildAttachmentMenu(),

        if (_showMoreUploads)
          _buildMoreUploadsMenu(),

        if (_showMoreTools)
          _buildMoreToolsMenu(),
      ],
    );
  }

  // ============================================================
  // FIRST PHASE
  // Matches your 2nd screenshot
  // ============================================================

  Widget _buildEmptyConversation() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLargeRobot(),

            const SizedBox(height: 30),

            const Text(
              'Select or start a conversation',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 14),

            const Text(
              'Choose a chat session from the left\n'
              'or create a new one to get started.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFCBD5E1),
                fontSize: 16,
                height: 1.55,
              ),
            ),

            const SizedBox(height: 28),

            SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _startNewChat,
                icon: const Icon(
                  Icons.chat_bubble_outline,
                  size: 19,
                ),
                label: const Text(
                  'New Chat',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F16D8),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLargeRobot() {
    return SizedBox(
      width: 190,
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            right: 22,
            child: _sparkle(
              color: const Color(0xFFD946EF),
              size: 22,
            ),
          ),

          Positioned(
            left: 18,
            top: 64,
            child: _sparkle(
              color: const Color(0xFF38BDF8),
              size: 15,
            ),
          ),

          Positioned(
            right: 8,
            top: 82,
            child: _sparkle(
              color: const Color(0xFF38BDF8),
              size: 14,
            ),
          ),

          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              color: const Color(0xFF111827),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: const Color(0xFF263244),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7C3AED).withValues(alpha: 0.10),
                  blurRadius: 30,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: const Icon(
              Icons.smart_toy_outlined,
              color: Color(0xFFA78BFA),
              size: 76,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sparkle({
    required Color color,
    required double size,
  }) {
    return Icon(
      Icons.auto_awesome,
      color: color,
      size: size,
    );
  }

  // ============================================================
  // CHAT
  // ============================================================

  Widget _buildChatMessages() {
    if (_messages.isEmpty) {
      return _buildNewConversationWelcome();
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        28,
        28,
        28,
        20,
      ),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];

        return _buildMessageBubble(message);
      },
    );
  }

  Widget _buildNewConversationWelcome() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildRobotIcon(size: 82),

            const SizedBox(height: 22),

            const Text(
              'Hi! I’m Acadexa Tutor',
              style: TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Ask me anything about your studies.\n'
              'I can help explain concepts, create practice problems,\n'
              'and guide your learning.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 14,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 25),

            Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children: [
                _suggestionButton(
                  'Explain photosynthesis',
                  Icons.eco_outlined,
                ),
                _suggestionButton(
                  'Help me with derivatives',
                  Icons.functions,
                ),
                _suggestionButton(
                  'Quiz me on Chapter 5',
                  Icons.quiz_outlined,
                ),
                _suggestionButton(
                  'What’s the best way to study?',
                  Icons.lightbulb_outline,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _suggestionButton(
    String text,
    IconData icon,
  ) {
    return OutlinedButton.icon(
      onPressed: () {
        _messageController.text = text;
        _sendMessage();
      },
      icon: Icon(
        icon,
        size: 17,
        color: const Color(0xFFCBD5E1),
      ),
      label: Text(
        text,
        overflow: TextOverflow.ellipsis,
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFFE2E8F0),
        side: const BorderSide(
          color: Color(0xFF334155),
        ),
        backgroundColor: const Color(0xFF070D1D),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(_ChatMessage message) {
    final bool isUser = message.isUser;

    return Align(
      alignment:
          isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 700,
        ),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isUser
              ? const Color(0xFF4C1D95)
              : const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isUser
                ? const Color(0xFF6D28D9)
                : const Color(0xFF1E293B),
          ),
        ),
        child: Text(
          message.text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // CHAT COMPOSER
  // ============================================================

  Widget _buildChatComposer() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          18,
          8,
          18,
          18,
        ),
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 1100,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF070D1D),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xFF263244),
            ),
          ),
          child: Column(
            children: [
              if (_attachedFiles.isNotEmpty)
                _buildAttachmentPreview(),

              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(width: 6),

                  _composerIconButton(
                    icon: Icons.add,
                    tooltip: 'Add files and tools',
                    onPressed: _toggleAttachmentMenu,
                  ),

                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      focusNode: _messageFocusNode,
                      minLines: 1,
                      maxLines: 5,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      textInputAction: TextInputAction.newline,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: const InputDecoration(
                        hintText: 'Ask your AI tutor anything...',
                        hintStyle: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),

                  _composerIconButton(
                    icon: _isRecording
                        ? Icons.stop
                        : Icons.mic_none,
                    tooltip: _isRecording
                        ? 'Stop recording'
                        : 'Use microphone',
                    active: _isRecording,
                    onPressed: _toggleMicrophone,
                  ),

                  const SizedBox(width: 4),

                  Container(
                    margin: const EdgeInsets.only(
                      right: 6,
                      bottom: 6,
                    ),
                    child: Material(
                      color: const Color(0xFF6D28D9),
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: _sendMessage,
                        child: const SizedBox(
                          width: 42,
                          height: 42,
                          child: Icon(
                            Icons.arrow_upward,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttachmentPreview() {
    return SizedBox(
      height: 58,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(
          12,
          10,
          12,
          4,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: _attachedFiles.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final file = _attachedFiles[index];

          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF111827),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF334155),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.insert_drive_file_outlined,
                  color: Color(0xFFA78BFA),
                  size: 17,
                ),
                const SizedBox(width: 7),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 180,
                  ),
                  child: Text(
                    file.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _attachedFiles.removeAt(index);
                    });
                  },
                  child: const Icon(
                    Icons.close,
                    color: Color(0xFF94A3B8),
                    size: 15,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _composerIconButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
    bool active = false,
  }) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: active
              ? const Color(0xFFF472B6)
              : const Color(0xFFCBD5E1),
          size: 21,
        ),
      ),
    );
  }

  // ============================================================
  // ATTACHMENT MENU
  // ============================================================

  Widget _buildAttachmentMenu() {
    return Positioned(
      left: 16,
      bottom: 84,
      child: _menuContainer(
        width: 225,
        children: [
          _menuItem(
            icon: Icons.file_upload_outlined,
            title: 'Upload files',
            onTap: _pickFiles,
          ),
          _menuItem(
            icon: Icons.cloud_outlined,
            title: 'Add from Drive',
            onTap: _addFromDrive,
          ),
          _menuItem(
            icon: Icons.more_horiz,
            title: 'More uploads',
            showArrow: true,
            selected: _showMoreUploads,
            onTap: () {
              setState(() {
                _showAttachmentMenu = false;
                _showMoreUploads = true;
                _showMoreTools = false;
              });
            },
          ),

          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            child: Divider(
              color: Color(0xFF253047),
              height: 1,
            ),
          ),

          _menuItem(
            icon: Icons.image_outlined,
            title: 'Create image',
            onTap: () => _toolSelected('Create image'),
          ),
          _menuItem(
            icon: Icons.music_note_outlined,
            title: 'Create music',
            onTap: () => _toolSelected('Create music'),
          ),
          _menuItem(
            icon: Icons.dashboard_customize_outlined,
            title: 'Canvas',
            onTap: () => _toolSelected('Canvas'),
          ),
          _menuItem(
            icon: Icons.search,
            title: 'Deep Research',
            onTap: () => _toolSelected('Deep Research'),
          ),
          _menuItem(
            icon: Icons.school_outlined,
            title: 'Guided Learning',
            onTap: () => _toolSelected('Guided Learning'),
          ),
          _menuItem(
            icon: Icons.more_horiz,
            title: 'More tools',
            showArrow: true,
            selected: _showMoreTools,
            onTap: () {
              setState(() {
                _showAttachmentMenu = false;
                _showMoreTools = true;
                _showMoreUploads = false;
              });
            },
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MORE UPLOADS
  // ============================================================

  Widget _buildMoreUploadsMenu() {
    return Positioned(
      left: 244,
      bottom: 190,
      child: _menuContainer(
        width: 190,
        children: [
          _menuItem(
            icon: Icons.assignment_outlined,
            title: 'Assignment',
            onTap: () => _pickFiles(
              dialogTitle: 'Select assignment',
            ),
          ),
          _menuItem(
            icon: Icons.note_alt_outlined,
            title: 'Notes',
            onTap: () => _pickFiles(
              dialogTitle: 'Select notes',
            ),
          ),
          _menuItem(
            icon: Icons.description_outlined,
            title: 'Resume',
            onTap: () => _pickFiles(
              dialogTitle: 'Select resume',
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MORE TOOLS
  // ============================================================

  Widget _buildMoreToolsMenu() {
    return Positioned(
      left: 244,
      bottom: 84,
      child: _menuContainer(
        width: 210,
        children: [
          _menuItem(
            icon: Icons.travel_explore_outlined,
            title: 'Web Search',
            onTap: () => _toolSelected('Web Search'),
          ),
          _menuItem(
            icon: Icons.calculate_outlined,
            title: 'Calculator',
            onTap: () => _toolSelected('Calculator'),
          ),
          _menuItem(
            icon: Icons.calendar_month_outlined,
            title: 'Study Planner',
            onTap: () => _toolSelected('Study Planner'),
          ),
          _menuItem(
            icon: Icons.quiz_outlined,
            title: 'Quiz Generator',
            onTap: () => _toolSelected('Quiz Generator'),
          ),
          _menuItem(
            icon: Icons.summarize_outlined,
            title: 'Summarize',
            onTap: () => _toolSelected('Summarize'),
          ),
          _menuItem(
            icon: Icons.lightbulb_outline,
            title: 'Explain',
            onTap: () => _toolSelected('Explain'),
          ),
          _menuItem(
            icon: Icons.translate_outlined,
            title: 'Translate',
            onTap: () => _toolSelected('Translate'),
          ),
          _menuItem(
            icon: Icons.code,
            title: 'Code Assistant',
            onTap: () => _toolSelected('Code Assistant'),
          ),
        ],
      ),
    );
  }

  Widget _menuContainer({
    required double width,
    required List<Widget> children,
  }) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF080E20),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFF334155),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.45),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool showArrow = false,
    bool selected = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 1,
      ),
      child: Material(
        color: selected
            ? const Color(0xFF4C1D95)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(7),
        child: InkWell(
          borderRadius: BorderRadius.circular(7),
          onTap: onTap,
          child: Container(
            height: 39,
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: const Color(0xFFCBD5E1),
                  size: 17,
                ),

                const SizedBox(width: 11),

                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                if (showArrow)
                  const Icon(
                    Icons.chevron_right,
                    color: Color(0xFFCBD5E1),
                    size: 18,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // FILE PICKER
  // ============================================================

  Future<void> _pickFiles({
  String? dialogTitle,
}) async {
  _closeMenus();

  try {
    final List<PlatformFile> files = await FilePicker.pickFiles(
      type: FileType.any,
      dialogTitle: dialogTitle,
    );

    if (!mounted || files.isEmpty) {
      return;
    }

    setState(() {
      _attachedFiles.addAll(files);
    });

    _showMessage(
      '${files.length} file${files.length == 1 ? '' : 's'} attached.',
    );
  } catch (e) {
    _showMessage(
      'Could not open the file picker: $e',
    );
  }
}
  // ============================================================
  // GOOGLE DRIVE
  // ============================================================
 Future<void> _addFromDrive() async {
  _closeMenus();

  final GoogleDriveFile? selectedFile =
      await showDialog<GoogleDriveFile>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return GoogleDrivePicker(
        service: _googleDriveService,
      );
    },
  );

  if (!mounted || selectedFile == null) {
    return;
  }

  _attachDriveFile(selectedFile);
}
Future<void> _attachDriveFile(GoogleDriveFile file) async {
  try {
    _showMessage(
      'Downloading ${file.name}...',
    );

    final String accessToken =
        await _googleDriveService.authorizeDrive();

    final List<int> bytes =
        await _googleDriveService.downloadFile(
      accessToken: accessToken,
      fileId: file.id,
    );

    if (!mounted) return;

    if (bytes.isEmpty) {
      _showMessage(
        'Could not download ${file.name}.',
      );
      return;
    }

    _showMessage(
      '${file.name} downloaded successfully.',
    );

  } on GoogleDriveException catch (e) {
    if (!mounted) return;

    _showMessage(e.message);
  } catch (e) {
    if (!mounted) return;

    _showMessage(
      'Could not download the Drive file: $e',
    );
  }
}
  // ============================================================
  // TOOLS
  // ============================================================
  void _toolSelected(String tool) {
    _closeMenus();

    _showMessage(
      '$tool selected.',
    );

    if (_selectedSessionIndex == null) {
      _startNewChat();
    }

    _messageController.text = '$tool: ';
    _messageFocusNode.requestFocus();
  }

  // ============================================================
  // MICROPHONE
  // ============================================================

  Future<void> _toggleMicrophone() async {
  if (_isRecording) {
    await _stopRecording();
    return;
  }

  try {
    final bool permission =
        await _audioRecorder.hasPermission(
      request: true,
    );

    if (!permission) {
      _showMessage(
        'Microphone permission was not granted. '
        'Please allow microphone access in Chrome.',
      );
      return;
    }

    await _audioRecorder.start(
      const RecordConfig(
        encoder: AudioEncoder.opus,
        numChannels: 1,
        echoCancel: true,
        noiseSuppress: true,
      ),
      path: '',
    );

    if (!mounted) return;

    setState(() {
      _isRecording = true;
    });

    _showMessage(
      'Recording started. Tap the microphone again to stop.',
    );
  } catch (e) {
    if (!mounted) return;

    setState(() {
      _isRecording = false;
    });

    _showMessage(
      'Microphone could not be started: $e',
    );
  }
}

  Future<void> _stopRecording() async {
    try {
      final String? path = await _audioRecorder.stop();

      setState(() {
        _isRecording = false;
      });

      if (path != null) {
        _showMessage(
          'Voice recording finished.',
        );
      }
    } catch (e) {
      setState(() {
        _isRecording = false;
      });

      _showMessage(
        'Could not stop the recording.',
      );
    }
  }
  // ============================================================
  // NEW CHAT
  // ============================================================
  void _startNewChat() {
    final String customName =
        _sessionController.text.trim();

    final String title = customName.isEmpty
        ? 'Chat ${_formatCurrentTime()}'
        : customName;

    final newSession = _TutorSession(
      title: title,
      messages: 0,
    );

    setState(() {
      _sessions.insert(0, newSession);
      _selectedSessionIndex = 0;
      _messages.clear();
      _attachedFiles.clear();
      _sessionController.clear();

      _showAttachmentMenu = false;
      _showMoreUploads = false;
      _showMoreTools = false;
    });

    _messageFocusNode.requestFocus();
  }

  String _formatCurrentTime() {
    final now = DateTime.now();

    final hour = now.hour == 0
        ? 12
        : now.hour > 12
            ? now.hour - 12
            : now.hour;

    final minute =
        now.minute.toString().padLeft(2, '0');

    final period = now.hour >= 12 ? 'PM' : 'AM';

    return '${_monthName(now.month)} ${now.day}, '
        '$hour:$minute $period';
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

  // ============================================================
  // SESSION
  // ============================================================

  void _loadSession(int index) {
    setState(() {
      _messages.clear();

      if (index == 0) {
        _messages.addAll([
          const _ChatMessage(
            text: 'Can you explain algorithms?',
            isUser: true,
          ),
          const _ChatMessage(
            text:
                'Of course! An algorithm is a step-by-step '
                'procedure used to solve a problem or perform '
                'a computation.',
            isUser: false,
          ),
          const _ChatMessage(
            text:
                'Would you like me to explain searching, '
                'sorting, or graph algorithms?',
            isUser: false,
          ),
        ]);
      }
    });
  }

  void _deleteSession(int index) {
    setState(() {
      _sessions.removeAt(index);

      if (_selectedSessionIndex == index) {
        _selectedSessionIndex = null;
        _messages.clear();
      } else if (_selectedSessionIndex != null &&
          _selectedSessionIndex! > index) {
        _selectedSessionIndex =
            _selectedSessionIndex! - 1;
      }
    });
  }

  // ============================================================
  // SEND MESSAGE
  // ============================================================

  void _sendMessage() {
    final text = _messageController.text.trim();

    if (text.isEmpty && _attachedFiles.isEmpty) {
      return;
    }

    if (_selectedSessionIndex == null) {
      _startNewChat();
    }

    final String messageText = text.isEmpty
        ? 'Please analyze the attached file.'
        : text;

    setState(() {
      _messages.add(
        _ChatMessage(
          text: messageText,
          isUser: true,
        ),
      );

      if (_selectedSessionIndex != null) {
        final index = _selectedSessionIndex!;

        if (index < _sessions.length) {
          _sessions[index] = _TutorSession(
            title: _sessions[index].title,
            messages: _messages.length,
          );
        }
      }

      _messageController.clear();
    });

    Future.delayed(
      const Duration(milliseconds: 600),
      () {
        if (!mounted) return;

        setState(() {
          _messages.add(
            _ChatMessage(
              text: _generateTutorResponse(messageText),
              isUser: false,
            ),
          );

          if (_selectedSessionIndex != null) {
            final index = _selectedSessionIndex!;

            if (index < _sessions.length) {
              _sessions[index] = _TutorSession(
                title: _sessions[index].title,
                messages: _messages.length,
              );
            }
          }
        });
      },
    );
  }

  String _generateTutorResponse(String text) {
    final lower = text.toLowerCase();

    if (lower.contains('photosynthesis')) {
      return 'Photosynthesis is the process plants use to convert '
          'light energy into chemical energy. It mainly occurs in '
          'the chloroplasts and uses carbon dioxide and water to '
          'produce glucose and oxygen.';
    }

    if (lower.contains('derivative') ||
        lower.contains('calculus')) {
      return 'A derivative measures how a function changes as its '
          'input changes. For example, if f(x) = x², then '
          'f′(x) = 2x.';
    }

    if (lower.contains('quiz')) {
      return 'Sure! Here is a quick question:\n\n'
          'Which data structure follows the FIFO principle?\n\n'
          'A. Stack\n'
          'B. Queue\n'
          'C. Tree\n'
          'D. Graph';
    }

    if (lower.contains('study')) {
      return 'A useful study approach is to divide your work into '
          'small focused sessions, actively recall the material, '
          'practice problems, and review difficult topics over '
          'multiple days.';
    }

    return 'I’m Acadexa Tutor. I can help you understand concepts, '
        'solve practice problems, create quizzes, summarize study '
        'materials, and build a study plan.';
  }

  // ============================================================
  // MENU HELPERS
  // ============================================================

  void _toggleAttachmentMenu() {
    setState(() {
      _showAttachmentMenu = !_showAttachmentMenu;
      _showMoreUploads = false;
      _showMoreTools = false;
    });
  }

  void _closeMenus() {
    if (!mounted) return;

    setState(() {
      _showAttachmentMenu = false;
      _showMoreUploads = false;
      _showMoreTools = false;
    });
  }

  // ============================================================
  // ROBOT ICON
  // ============================================================

  Widget _buildRobotIcon({
    double size = 45,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF21104C),
        borderRadius: BorderRadius.circular(
          size * 0.22,
        ),
        border: Border.all(
          color: const Color(0xFF7C3AED),
        ),
      ),
      child: Icon(
        Icons.smart_toy_outlined,
        color: const Color(0xFFA78BFA),
        size: size * 0.52,
      ),
    );
  }
  // ============================================================
  // MESSAGE
  // ============================================================
  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF111827),
          duration: const Duration(seconds: 2),
        ),
      );
  }
}
// ================================================================
// MODELS
// ================================================================
class _TutorSession {
  const _TutorSession({
    required this.title,
    required this.messages,
  });

  final String title;
  final int messages;
}

class _ChatMessage {
  const _ChatMessage({
    required this.text,
    required this.isUser,
  });

  final String text;
  final bool isUser;
}