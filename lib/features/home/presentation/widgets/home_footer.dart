import 'package:flutter/material.dart';

class HomeFooter extends StatelessWidget {
  const HomeFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF050817),
      padding: const EdgeInsets.fromLTRB(40, 70, 40, 30),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1300),
          child: Column(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final isMobile = constraints.maxWidth < 850;

                  if (isMobile) {
                    return const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _BrandSection(),
                        SizedBox(height: 45),
                        _MobileLinks(),
                      ],
                    );
                  }

                  return const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: _BrandSection(),
                      ),

                      SizedBox(width: 60),

                      Expanded(
                        flex: 2,
                        child: _FooterColumn(
                          title: 'Features',
                          items: [
                            'AI Study Planner',
                            'Goal Tracking',
                            'Subjects',
                            'Flashcards',
                            'Quizzes',
                            'Exam Preparation',
                            'Study Analytics',
                          ],
                        ),
                      ),

                      Expanded(
                        flex: 2,
                        child: _FooterColumn(
                          title: 'Study Tools',
                          items: [
                            'AI Tutor',
                            'Study Plans',
                            'Flashcards',
                            'Practice Quizzes',
                            'Study Goals',
                            'Progress Reports',
                            'Exam Planner',
                          ],
                        ),
                      ),

                      Expanded(
                        flex: 2,
                        child: _FooterColumn(
                          title: 'Resources',
                          items: [
                            'Dashboard',
                            'Analytics',
                            'Study Tips',
                            'How It Works',
                            'FAQ',
                            'Help Center',
                          ],
                        ),
                      ),

                      Expanded(
                        flex: 2,
                        child: _CompanyColumn(),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 65),

              Divider(
                color: Colors.white.withValues(alpha: 0.08),
                height: 1,
              ),

              const SizedBox(height: 25),

              LayoutBuilder(
                builder: (context, constraints) {
                  final isMobile = constraints.maxWidth < 650;

                  if (isMobile) {
                    return const Column(
                      children: [
                        Text(
                          '© 2026 Acadexa. All rights reserved.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF737B91),
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 15),
                        _BottomLinks(),
                      ],
                    );
                  }

                  return const Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '© 2026 Acadexa. All rights reserved.',
                        style: TextStyle(
                          color: Color(0xFF737B91),
                          fontSize: 12,
                        ),
                      ),
                      _BottomLinks(),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===============================================================
// BRAND
// ===============================================================

class _BrandSection extends StatelessWidget {
  const _BrandSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF315EFF),
                    Color(0xFF7C3AED),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.school_rounded,
                color: Colors.white,
                size: 23,
              ),
            ),

            const SizedBox(width: 12),

            const Text(
              'Acadexa',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 300,
          ),
          child: const Text(
            'Your intelligent academic companion for smarter '
            'planning, focused studying, and better progress.',
            style: TextStyle(
              color: Color(0xFF8E96AA),
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ),

        const SizedBox(height: 25),

        const Row(
          children: [
            _SocialButton(
              icon: Icons.language_rounded,
            ),
            SizedBox(width: 10),
            _SocialButton(
              icon: Icons.play_circle_outline_rounded,
            ),
            SizedBox(width: 10),
            _SocialButton(
              icon: Icons.code_rounded,
            ),
            SizedBox(width: 10),
            _SocialButton(
              icon: Icons.mail_outline_rounded,
            ),
          ],
        ),
      ],
    );
  }
}

// ===============================================================
// FOOTER COLUMN
// ===============================================================

class _FooterColumn extends StatelessWidget {
  final String title;
  final List<String> items;

  const _FooterColumn({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 18),

        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(
              bottom: 13,
            ),
            child: _FooterLink(
              text: item,
            ),
          ),
        ),
      ],
    );
  }
}

// ===============================================================
// COMPANY + LEGAL
// ===============================================================

class _CompanyColumn extends StatelessWidget {
  const _CompanyColumn();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Company',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),

        SizedBox(height: 18),

        _FooterLink(text: 'About Acadexa'),
        SizedBox(height: 13),

        _FooterLink(text: 'Contact'),
        SizedBox(height: 13),

        _FooterLink(text: 'Feedback'),
        SizedBox(height: 13),

        _FooterLink(text: 'Pricing'),

        SizedBox(height: 30),

        Text(
          'Legal',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),

        SizedBox(height: 18),

        _FooterLink(text: 'Privacy Policy'),
        SizedBox(height: 13),

        _FooterLink(text: 'Terms of Service'),
      ],
    );
  }
}

// ===============================================================
// FOOTER LINK
// ===============================================================

class _FooterLink extends StatefulWidget {
  final String text;

  const _FooterLink({
    required this.text,
  });

  @override
  State<_FooterLink> createState() =>
      _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() => hovered = true);
      },
      onExit: (_) {
        setState(() => hovered = false);
      },
      child: GestureDetector(
        onTap: () {
          // TODO: Add navigation
        },
        child: AnimatedDefaultTextStyle(
          duration: const Duration(
            milliseconds: 150,
          ),
          style: TextStyle(
            color: hovered
                ? const Color(0xFF9B6CFF)
                : const Color(0xFF8E96AA),
            fontSize: 13,
            fontWeight: hovered
                ? FontWeight.w500
                : FontWeight.w400,
          ),
          child: Text(widget.text),
        ),
      ),
    );
  }
}

// ===============================================================
// SOCIAL BUTTON
// ===============================================================

class _SocialButton extends StatefulWidget {
  final IconData icon;

  const _SocialButton({
    required this.icon,
  });

  @override
  State<_SocialButton> createState() =>
      _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() => hovered = true);
      },
      onExit: (_) {
        setState(() => hovered = false);
      },
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 180,
        ),
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: hovered
              ? const Color(0xFF7C3AED)
                  .withValues(alpha: 0.15)
              : const Color(0xFF0C1125),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: hovered
                ? const Color(0xFF7C3AED)
                : Colors.white.withValues(
                    alpha: 0.08,
                  ),
          ),
        ),
        child: Icon(
          widget.icon,
          color: hovered
              ? const Color(0xFFA879FF)
              : const Color(0xFF9299AD),
          size: 18,
        ),
      ),
    );
  }
}

// ===============================================================
// BOTTOM
// ===============================================================

class _BottomLinks extends StatelessWidget {
  const _BottomLinks();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      alignment: WrapAlignment.center,
      spacing: 22,
      runSpacing: 10,
      children: [
        _FooterLink(
          text: 'Privacy',
        ),
        _FooterLink(
          text: 'Terms',
        ),
        _FooterLink(
          text: 'Accessibility',
        ),
        _FooterLink(
          text: 'English',
        ),
      ],
    );
  }
}

// ===============================================================
// MOBILE
// ===============================================================

class _MobileLinks extends StatelessWidget {
  const _MobileLinks();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 60,
      runSpacing: 45,
      children: [
        SizedBox(
          width: 150,
          child: _FooterColumn(
            title: 'Features',
            items: [
              'AI Study Planner',
              'Goal Tracking',
              'Subjects',
              'Flashcards',
              'Quizzes',
              'Exam Preparation',
              'Study Analytics',
            ],
          ),
        ),

        SizedBox(
          width: 150,
          child: _FooterColumn(
            title: 'Study Tools',
            items: [
              'AI Tutor',
              'Study Plans',
              'Flashcards',
              'Practice Quizzes',
              'Study Goals',
              'Progress Reports',
            ],
          ),
        ),

        SizedBox(
          width: 150,
          child: _FooterColumn(
            title: 'Resources',
            items: [
              'Dashboard',
              'Analytics',
              'Study Tips',
              'How It Works',
              'FAQ',
              'Help Center',
            ],
          ),
        ),

        SizedBox(
          width: 150,
          child: _CompanyColumn(),
        ),
      ],
    );
  }
}