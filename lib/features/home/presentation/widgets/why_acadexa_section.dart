import 'package:flutter/material.dart';

class WhyAcadexaSection extends StatelessWidget {
  const WhyAcadexaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final isMobile = width < 700;
        final isTablet = width >= 700 && width < 1100;

        return Container(
          width: double.infinity,
          color: const Color(0xFF020617),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 24 : 68,
            vertical: isMobile ? 70 : 110,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 1440,
              ),
              child: Column(
                children: [
                  // Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7C3AED)
                          .withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: const Color(0xFF7C3AED)
                            .withValues(alpha: 0.45),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.auto_awesome_rounded,
                          color: Color(0xFFB46CFF),
                          size: 15,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'WHY ACADEXA',
                          style: TextStyle(
                            color: Color(0xFFB46CFF),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Heading
                  Text(
                    'Everything you need to study smarter',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isMobile ? 30 : 42,
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                    ),
                  ),

                  const SizedBox(height: 16),

                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 700,
                    ),
                    child: const Text(
                      'Acadexa brings your goals, subjects, study plans, '
                      'exams, and progress together so you can spend less '
                      'time organizing and more time actually learning.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFA8AEC3),
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                  ),

                  SizedBox(height: isMobile ? 45 : 65),

                  // Main cards
                  GridView.count(
                    crossAxisCount: isMobile
                        ? 1
                        : isTablet
                            ? 2
                            : 4,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: isMobile ? 1.9 : 1.05,
                    children: const [
                      _WhyCard(
                        icon: Icons.dashboard_customize_rounded,
                        title: 'One Academic Workspace',
                        description:
                            'Keep subjects, goals, study plans, exams, '
                            'and progress organized in one connected place.',
                        color: Color(0xFF8B5CF6),
                      ),
                      _WhyCard(
                        icon: Icons.auto_awesome_rounded,
                        title: 'AI That Plans With You',
                        description:
                            'Turn your workload, priorities, and available '
                            'time into focused study sessions.',
                        color: Color(0xFF3B82F6),
                      ),
                      _WhyCard(
                        icon: Icons.insights_rounded,
                        title: 'See Your Progress',
                        description:
                            'Understand what you have completed, where '
                            'you are improving, and what needs attention.',
                        color: Color(0xFF14B8A6),
                      ),
                      _WhyCard(
                        icon: Icons.school_rounded,
                        title: 'Built for Students',
                        description:
                            'From everyday study sessions to important '
                            'exams, Acadexa keeps your academic work focused.',
                        color: Color(0xFFF97316),
                      ),
                    ],
                  ),

                  SizedBox(height: isMobile ? 30 : 40),

                  // Bottom highlight
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 22 : 36,
                      vertical: isMobile ? 24 : 30,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF080D22),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: const Color(0xFF7C3AED)
                            .withValues(alpha: 0.30),
                      ),
                    ),
                    child: isMobile
                        ? const Column(
                            children: [
                              _BottomItem(
                                value: 'Plan',
                                label: 'Organize your study time',
                              ),
                              SizedBox(height: 25),
                              _Divider(),
                              SizedBox(height: 25),
                              _BottomItem(
                                value: 'Focus',
                                label: 'Know what to study next',
                              ),
                              SizedBox(height: 25),
                              _Divider(),
                              SizedBox(height: 25),
                              _BottomItem(
                                value: 'Track',
                                label: 'Measure your progress',
                              ),
                            ],
                          )
                        : const Row(
                            children: [
                              Expanded(
                                child: _BottomItem(
                                  value: 'Plan',
                                  label: 'Organize your study time',
                                ),
                              ),
                              SizedBox(
                                height: 55,
                                child: VerticalDivider(
                                  color: Color(0xFF252B46),
                                ),
                              ),
                              Expanded(
                                child: _BottomItem(
                                  value: 'Focus',
                                  label: 'Know what to study next',
                                ),
                              ),
                              SizedBox(
                                height: 55,
                                child: VerticalDivider(
                                  color: Color(0xFF252B46),
                                ),
                              ),
                              Expanded(
                                child: _BottomItem(
                                  value: 'Track',
                                  label: 'Measure your progress',
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _WhyCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _WhyCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  State<_WhyCard> createState() => _WhyCardState();
}

class _WhyCardState extends State<_WhyCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          isHovered = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: isHovered
            ? Matrix4.translationValues(0, -5, 0)
            : Matrix4.identity(),
        padding: const EdgeInsets.all(26),
        decoration: BoxDecoration(
          color: const Color(0xFF080D22),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isHovered
                ? widget.color.withValues(alpha: 0.65)
                : const Color(0xFF20263D),
          ),
          boxShadow: isHovered
              ? [
                  BoxShadow(
                    color: widget.color.withValues(alpha: 0.10),
                    blurRadius: 28,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: widget.color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: widget.color.withValues(alpha: 0.25),
                ),
              ),
              child: Icon(
                widget.icon,
                color: widget.color,
                size: 24,
              ),
            ),

            const SizedBox(height: 24),

            Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: Text(
                widget.description,
                style: const TextStyle(
                  color: Color(0xFFA8AEC3),
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Text(
                  'Explore',
                  style: TextStyle(
                    color: widget.color,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 7),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: widget.color,
                  size: 17,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomItem extends StatelessWidget {
  final String value;
  final String label;

  const _BottomItem({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) {
            return const LinearGradient(
              colors: [
                Color(0xFF3B82F6),
                Color(0xFF8B5CF6),
                Color(0xFFD946EF),
              ],
            ).createShader(bounds);
          },
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF9299B0),
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 1,
      color: const Color(0xFF252B46),
    );
  }
}