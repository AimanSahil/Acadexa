import 'package:flutter/material.dart';

class HomeCtaSection extends StatelessWidget {
  const HomeCtaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final isMobile = width < 700;
        final isTablet = width >= 700 && width < 1100;

        return Padding(
          padding: EdgeInsets.fromLTRB(
            isMobile ? 24 : 68,
            isMobile ? 24 : 32,
            isMobile ? 24 : 68,
            isMobile ? 40 : 48,
       ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 1440,
              ),
              child: Container(
                width: double.infinity,

                // More compact on desktop
                height: isMobile
                    ? 260
                    : isTablet
                        ? 175
                        : 165,

                clipBehavior: Clip.antiAlias,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF6D28D9),
                    width: 1,
                  ),
                ),

                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    
                    // BACKGROUND ARTWORK
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/home/cta_background.png',
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        filterQuality: FilterQuality.high,
                      ),
                    ),

                    
                    // SUBTLE DARK OVERLAY
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withValues(
                          alpha: 0.04,
                        ),
                      ),
                    ),

                    
                    // CTA CONTENT
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 20 : 32,
                          vertical: isMobile ? 22 : 16,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            
                            // TITLE
                            Text(
                              'Ready to transform your study habits?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isMobile ? 22 : 28,
                                height: 1.15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            const SizedBox(height: 7),

                            
                            // DESCRIPTION
                           Text(
                              'Join thousands of students who are achieving more '
                              'with focused planning.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withValues(
                                  alpha: 0.82,
                                ),
                                fontSize: isMobile ? 13 : 14,
                                height: 1.4,
                                fontWeight: FontWeight.w400,
                              ),
                            ),

                            SizedBox(
                              height: isMobile ? 20 : 16,
                            ),

                            // CTA BUTTON
                           SizedBox(
                              width: isMobile
                                  ? double.infinity
                                  : 290,
                              height: 46,
                              child: ElevatedButton(
                                onPressed: () {},

                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor:
                                      const Color(0xFF4C1DFF),

                                  elevation: 6,

                                  shadowColor:
                                      Colors.black.withValues(
                                    alpha: 0.22,
                                  ),

                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                  ),

                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(9),
                                  ),
                                ),

                                child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Start Now – It's Free",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight:
                                            FontWeight.w700,
                                      ),
                                    ),

                                    SizedBox(width: 14),

                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}