import 'package:flutter/material.dart';

class PreferencesStep extends StatelessWidget {
  final String selectedStudyTime;
  final ValueChanged<String> onStudyTimeChanged;

  const PreferencesStep({
    super.key,
    required this.selectedStudyTime,
    required this.onStudyTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    const studyTimes = [
      'Morning',
      'Afternoon',
      'Evening',
      'Night',
    ];

    return _StepContainer(
      title: 'Choose your preferences',
      subtitle:
          'When do you usually feel most comfortable studying?',
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Preferred study time',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 14),

          ...studyTimes.map(
            (time) {
              final selected =
                  selectedStudyTime == time;

              return Padding(
                padding:
                    const EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                  onTap: () =>
                      onStudyTimeChanged(time),
                  child: AnimatedContainer(
                    duration:
                        const Duration(milliseconds: 200),
                    padding:
                        const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFF1B1235)
                          : const Color(0xFF0A0B1D),
                      borderRadius:
                          BorderRadius.circular(14),
                      border: Border.all(
                        color: selected
                            ? const Color(0xFF7C3AED)
                            : const Color(0xFF292B43),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0xFF7C3AED)
                                : const Color(0xFF17182B),
                            borderRadius:
                                BorderRadius.circular(11),
                          ),
                          child: Icon(
                            _getIcon(time),
                            color: selected
                                ? Colors.white
                                : const Color(
                                    0xFF9A9CAE,
                                  ),
                          ),
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: Text(
                            time,
                            style: TextStyle(
                              color: selected
                                  ? Colors.white
                                  : const Color(
                                      0xFFD0D1DB,
                                    ),
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                        ),

                        if (selected)
                          const Icon(
                            Icons.check_circle_rounded,
                            color:
                                Color(0xFFA56BFF),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  IconData _getIcon(String time) {
    switch (time) {
      case 'Morning':
        return Icons.wb_sunny_outlined;

      case 'Afternoon':
        return Icons.wb_sunny;

      case 'Evening':
        return Icons.wb_twilight;

      case 'Night':
        return Icons.nightlight_outlined;

      default:
        return Icons.access_time_rounded;
    }
  }
}

class _StepContainer extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _StepContainer({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0C20),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF252741),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFF9699AD),
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 25),
          child,
        ],
      ),
    );
  }
}