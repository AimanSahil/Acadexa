import 'package:flutter/material.dart';

class DashboardHeader extends StatefulWidget {
  const DashboardHeader({super.key});

  @override
  State<DashboardHeader> createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader> {
  final TextEditingController _searchController =
      TextEditingController();

  final FocusNode _searchFocusNode = FocusNode();

  bool _showSearchResults = false;

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      if (mounted) {
        setState(() {
          _showSearchResults =
              _searchController.text.trim().isNotEmpty;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 700;

        if (isMobile) {
          return _buildMobileHeader(
            context,
            theme,
            colorScheme,
          );
        }

        return _buildDesktopHeader(
          context,
          theme,
          colorScheme,
        );
      },
    );
  }

  Widget _buildDesktopHeader(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dashboard',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.7,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Track your progress and stay on top of your studies.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 30),

            _buildSearchBox(
              context,
              colorScheme,
              width: 295,
            ),

            const SizedBox(width: 14),

            _buildNotificationButton(
              context,
              colorScheme,
            ),

            const SizedBox(width: 12),

            _buildProfileButton(
              context,
              colorScheme,
            ),
          ],
        ),

        if (_showSearchResults) ...[
          const SizedBox(height: 10),
          _buildSearchResultPanel(
            context,
            colorScheme,
          ),
        ],
      ],
    );
  }

  Widget _buildMobileHeader(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dashboard',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Stay on top of your studies.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            _buildNotificationButton(
              context,
              colorScheme,
            ),
            const SizedBox(width: 8),
            _buildProfileButton(
              context,
              colorScheme,
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildSearchBox(
          context,
          colorScheme,
          width: double.infinity,
        ),
        if (_showSearchResults) ...[
          const SizedBox(height: 10),
          _buildSearchResultPanel(
            context,
            colorScheme,
          ),
        ],
      ],
    );
  }

  Widget _buildSearchBox(
    BuildContext context,
    ColorScheme colorScheme, {
    required double width,
  }) {
    return SizedBox(
      width: width,
      height: 46,
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        onTap: () {
          setState(() {});
        },
        decoration: InputDecoration(
          hintText: 'Search anything...',
          hintStyle: TextStyle(
            color: colorScheme.onSurfaceVariant.withValues(
              alpha: 0.7,
            ),
            fontSize: 13,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            size: 20,
            color: colorScheme.onSurfaceVariant,
          ),
          suffixIcon: _searchController.text.isEmpty
              ? null
              : IconButton(
                  tooltip: 'Clear search',
                  onPressed: () {
                    _searchController.clear();
                    _searchFocusNode.requestFocus();
                  },
                  icon: const Icon(
                    Icons.close_rounded,
                    size: 18,
                  ),
                ),
          filled: true,
          fillColor: colorScheme.surfaceContainerHighest
              .withValues(alpha: 0.35),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: BorderSide(
              color: colorScheme.outline.withValues(
                alpha: 0.15,
              ),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: BorderSide(
              color: colorScheme.outline.withValues(
                alpha: 0.15,
              ),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: BorderSide(
              color: colorScheme.primary.withValues(
                alpha: 0.75,
              ),
              width: 1.3,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationButton(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    return PopupMenuButton<String>(
      tooltip: 'Notifications',
      offset: const Offset(0, 52),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      onSelected: (value) {
        if (value == 'task') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Task reminder selected',
              ),
            ),
          );
        }

        if (value == 'goal') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Goal reminder selected',
              ),
            ),
          );
        }
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem<String>(
            value: 'task',
            child: SizedBox(
              width: 260,
              child: Row(
                children: [
                  _notificationIcon(
                    colorScheme,
                    Icons.task_alt_rounded,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Task reminder',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'You have tasks scheduled today.',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          PopupMenuItem<String>(
            value: 'goal',
            child: SizedBox(
              width: 260,
              child: Row(
                children: [
                  _notificationIcon(
                    colorScheme,
                    Icons.flag_rounded,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Goal progress',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Keep working toward your goals.',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ];
      },
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest
              .withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: colorScheme.outline.withValues(
              alpha: 0.15,
            ),
          ),
        ),
        child: Stack(
          children: [
            const Center(
              child: Icon(
                Icons.notifications_none_rounded,
                size: 21,
              ),
            ),
            Positioned(
              top: 9,
              right: 10,
              child: Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _notificationIcon(
    ColorScheme colorScheme,
    IconData icon,
  ) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(
          alpha: 0.12,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        icon,
        size: 19,
        color: colorScheme.primary,
      ),
    );
  }

  Widget _buildProfileButton(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    return PopupMenuButton<String>(
      tooltip: 'Profile',
      offset: const Offset(0, 54),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      onSelected: (value) {
        if (value == 'profile') {
          // Profile route will be connected later.
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Profile will be available soon.',
              ),
            ),
          );
        }

        if (value == 'settings') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Settings will be available soon.',
              ),
            ),
          );
        }

        if (value == 'logout') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Logout will be connected to Firebase Auth.',
              ),
            ),
          );
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: 'profile',
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.person_outline_rounded),
            title: Text('Profile'),
          ),
        ),
        PopupMenuItem(
          value: 'settings',
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.settings_outlined),
            title: Text('Settings'),
          ),
        ),
        PopupMenuDivider(),
        PopupMenuItem(
          value: 'logout',
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.logout_rounded),
            title: Text('Logout'),
          ),
        ),
      ],
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.primary,
              colorScheme.secondary,
            ],
          ),
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Text(
            'SA',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResultPanel(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    final query = _searchController.text.trim();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest
            .withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: colorScheme.primary.withValues(
            alpha: 0.18,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            color: colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Searching Acadexa for "$query"...',
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}