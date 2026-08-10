import 'package:flutter/material.dart';

import '../widgets/feature_section.dart';
import '../widgets/hero_section.dart';
import '../widgets/home_cta_section.dart';
import '../widgets/home_navbar.dart';
import '../widgets/how_it_works_section.dart';
import '../widgets/planner_showcase_section.dart';
import '../widgets/academic_workflow_section.dart';
import '../widgets/why_acadexa_section.dart';
import '../widgets/home_faq_section.dart';
import '../widgets/final_cta_section.dart';
import '../widgets/home_footer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: const [
            HomeNavbar(),
            HeroSection(),
            FeatureSection(),
            HomeCtaSection(),
            HowItWorksSection(),
            PlannerShowcaseSection(),
            AcademicWorkflowSection(),
            WhyAcadexaSection(),
            HomeFaqSection(),
            FinalCtaSection(),
            HomeFooter(),
          ],
        ),
      ),
    );
  }
}