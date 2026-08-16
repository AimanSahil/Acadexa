import 'package:flutter/material.dart';

class OnboardingHeader extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const OnboardingHeader({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (currentStep + 1) / totalSteps;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF7438E8),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7438E8)
                        .withValues(alpha: 0.35),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: const Icon(
                Icons.school_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Acadexa',
              style: TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),

        const SizedBox(height: 30),

        const Text(
          'Let’s personalize your\nlearning experience',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            height: 1.15,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 10),

        const Text(
          'Tell us a little about yourself so Acadexa '
          'can create a better study experience for you.',
          style: TextStyle(
            color: Color(0xFF9CA3B5),
            fontSize: 15,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 25),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Step ${currentStep + 1} of $totalSteps',
              style: const TextStyle(
                color: Color(0xFFB8A6E8),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${(progress * 100).round()}%',
              style: const TextStyle(
                color: Color(0xFFB8A6E8),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: const Color(0xFF17182B),
            valueColor:
                const AlwaysStoppedAnimation<Color>(
              Color(0xFF7C3AED),
            ),
          ),
        ),
      ],
    );
  }
}