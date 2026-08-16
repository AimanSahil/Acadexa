import 'package:flutter/material.dart';

class OnboardingButton extends StatelessWidget {
  final VoidCallback? onNext;
  final VoidCallback? onBack;
  final bool isFirstStep;
  final bool isLastStep;
  final bool isLoading;

  const OnboardingButton({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.isFirstStep,
    required this.isLastStep,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!isFirstStep) ...[
          Expanded(
            flex: 1,
            child: SizedBox(
              height: 56,
              child: OutlinedButton(
                onPressed: isLoading ? null : onBack,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(
                    color: Color(0xFF34364D),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],

        Expanded(
          flex: 3,
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: isLoading ? null : onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF7C3AED),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(16),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Text(
                          isLastStep
                              ? 'Finish'
                              : 'Continue',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          isLastStep
                              ? Icons.check_rounded
                              : Icons
                                  .arrow_forward_rounded,
                          size: 20,
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }
}