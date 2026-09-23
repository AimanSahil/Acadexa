import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/main_app_shell.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  String _studyHoursRange = 'Last 7 Days';
  String _studyTrendRange = 'Last 30 Days';

  static const Color background = Color(0xFF020617);
  static const Color cardColor = Color(0xFF080D1F);
  static const Color cardColor2 = Color(0xFF0A1024);
  static const Color borderColor = Color(0xFF1D2942);

  static const Color brightPurple = Color(0xFF8B5CF6);
  static const Color lightPurple = Color(0xFFA78BFA);

  static const Color green = Color(0xFF22C55E);
  static const Color pink = Color(0xFFEC4899);
  static const Color mutedText = Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    return MainAppShell(
      selectedRoute: '/analytics',
      child: Scaffold(
        backgroundColor: background,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final bool isMobile = constraints.maxWidth < 850;

            return SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  isMobile ? 18 : 24,
                  isMobile ? 20 : 26,
                  isMobile ? 18 : 24,
                  30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(isMobile),
                    const SizedBox(height: 24),
                    _buildSummaryCards(isMobile),
                    const SizedBox(height: 20),
                    _buildCharts(isMobile),
                    const SizedBox(height: 20),
                    _buildSubjectPerformance(),
                    const SizedBox(height: 20),
                    _buildProductivityScore(isMobile),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Analytics',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(width: 9),
            ShaderMask(
              shaderCallback: (bounds) {
                return const LinearGradient(
                  colors: [
                    Color(0xFF8B5CF6),
                    Color(0xFFC084FC),
                  ],
                ).createShader(bounds);
              },
              child: const Icon(
                Icons.auto_awesome,
                size: 21,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'Track your study performance and progress',
          style: TextStyle(
            color: Color(0xFFCBD5E1),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards(bool isMobile) {
    final cards = [
      _SummaryData(
        title: 'Study Hours',
        value: '48.5h',
        subtitle: '↗ +15% vs last week',
        subtitleColor: green,
        icon: Icons.access_time_rounded,
      ),
      _SummaryData(
        title: 'Tasks Done',
        value: '0',
        subtitle: null,
        subtitleColor: null,
        icon: Icons.check_box_outlined,
      ),
      _SummaryData(
        title: 'Quiz Avg',
        value: '0%',
        subtitle: null,
        subtitleColor: null,
        icon: Icons.workspace_premium_outlined,
      ),
      _SummaryData(
        title: 'Study Streak',
        value: '7d',
        subtitle: '↗ days in a row',
        subtitleColor: green,
        icon: Icons.bolt_rounded,
      ),
    ];

    if (isMobile) {
      return Column(
        children: [
          for (int i = 0; i < cards.length; i++) ...[
            _buildSummaryCard(cards[i]),
            if (i != cards.length - 1)
              const SizedBox(height: 12),
          ],
        ],
      );
    }

    return Row(
      children: [
        for (int i = 0; i < cards.length; i++) ...[
          Expanded(
            child: _buildSummaryCard(cards[i]),
          ),
          if (i != cards.length - 1)
            const SizedBox(width: 18),
        ],
      ],
    );
  }

  Widget _buildSummaryCard(_SummaryData data) {
    return Container(
      height: 122,
      padding: const EdgeInsets.fromLTRB(
        22,
        17,
        20,
        17,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  data.value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    height: 1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (data.subtitle != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    data.subtitle!,
                    style: TextStyle(
                      color: data.subtitleColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
          _buildIconContainer(
            icon: data.icon,
            size: 48,
          ),
        ],
      ),
    );
  }

  Widget _buildIconContainer({
    required IconData icon,
    double size = 44,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF17113C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF21164F),
        ),
      ),
      child: Icon(
        icon,
        color: brightPurple,
        size: size * 0.52,
      ),
    );
  }

  Widget _buildCharts(bool isMobile) {
    if (isMobile) {
      return Column(
        children: [
          _buildStudyHoursCard(),
          const SizedBox(height: 18),
          _buildStudyTrendCard(),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildStudyHoursCard(),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: _buildStudyTrendCard(),
        ),
      ],
    );
  }

  Widget _buildChartContainer({
    required Widget child,
    required String title,
    required IconData icon,
    required String selectedValue,
    required List<String> options,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      height: 245,
      padding: const EdgeInsets.fromLTRB(
        20,
        16,
        18,
        13,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: lightPurple,
                size: 19,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _buildRangeDropdown(
                value: selectedValue,
                options: options,
                onChanged: onChanged,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildRangeDropdown({
    required String value,
    required List<String> options,
    required ValueChanged<String> onChanged,
  }) {
    return PopupMenuButton<String>(
      initialValue: value,
      onSelected: onChanged,
      color: const Color(0xFF0C1328),
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(9),
        side: const BorderSide(
          color: borderColor,
        ),
      ),
      itemBuilder: (context) {
        return options.map((option) {
          return PopupMenuItem<String>(
            value: option,
            child: Text(
              option,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          );
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF0B1225),
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: borderColor,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
              ),
            ),
            const SizedBox(width: 5),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: mutedText,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudyHoursCard() {
    return _buildChartContainer(
      title: 'Study Hours (Last 7 Days)',
      icon: Icons.bar_chart_rounded,
      selectedValue: _studyHoursRange,
      options: const [
        'Last 7 Days',
        'Last 14 Days',
        'Last 30 Days',
      ],
      onChanged: (value) {
        setState(() {
          _studyHoursRange = value;
        });
      },
      child: BarChart(
        BarChartData(
          minY: 0,
          maxY: 3.5,
          borderData: FlBorderData(
            show: false,
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: 1,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return const FlLine(
                color: Color(0xFF17213A),
                strokeWidth: 1,
              );
            },
            getDrawingVerticalLine: (value) {
              return const FlLine(
                color: Color(0xFF111A2F),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}h',
                    style: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 9,
                    ),
                  );
                },
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                getTitlesWidget: (value, meta) {
                  const labels = [
                    'Jul 24',
                    'Jul 25',
                    'Jul 26',
                    'Jul 27',
                    'Jul 28',
                    'Jul 29',
                    'Jul 30',
                  ];

                  final index = value.toInt();

                  if (index < 0 || index >= labels.length) {
                    return const SizedBox.shrink();
                  }

                  return Padding(
                    padding: const EdgeInsets.only(top: 7),
                    child: Text(
                      labels[index],
                      style: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 8.5,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => const Color(0xFF11182D),
              getTooltipItem: (
                group,
                groupIndex,
                rod,
                rodIndex,
              ) {
                return BarTooltipItem(
                  '${rod.toY.toStringAsFixed(1)}h',
                  const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),
          ),
          barGroups: [
            _bar(0, 3.0),
            _bar(1, 2.0),
            _bar(2, 1.0),
            _bar(3, 2.2),
            _bar(4, 2.6),
            _bar(5, 1.4),
            _bar(6, 2.8),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _bar(
    int x,
    double value,
  ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: value,
          width: 28,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
          gradient: const LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color(0xFF4820C8),
              Color(0xFF6938FF),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStudyTrendCard() {
    return _buildChartContainer(
      title: 'Study Trend (30 Days)',
      icon: Icons.show_chart_rounded,
      selectedValue: _studyTrendRange,
      options: const [
        'Last 30 Days',
        'Last 60 Days',
        'Last 90 Days',
      ],
      onChanged: (value) {
        setState(() {
          _studyTrendRange = value;
        });
      },
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: 8,
          minX: 0,
          maxX: 28,
          borderData: FlBorderData(
            show: false,
          ),
          gridData: FlGridData(
            show: true,
            horizontalInterval: 2,
            verticalInterval: 7,
            getDrawingHorizontalLine: (value) {
              return const FlLine(
                color: Color(0xFF17213A),
                strokeWidth: 1,
              );
            },
            getDrawingVerticalLine: (value) {
              return const FlLine(
                color: Color(0xFF111A2F),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                interval: 2,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 9,
                    ),
                  );
                },
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 21,
                interval: 7,
                getTitlesWidget: (value, meta) {
                  String text = '';

                  if (value == 0) {
                    text = 'Jul 2';
                  } else if (value == 7) {
                    text = 'Jul 9';
                  } else if (value == 14) {
                    text = 'Jul 16';
                  } else if (value == 21) {
                    text = 'Jul 23';
                  } else if (value == 28) {
                    text = 'Jul 30';
                  }

                  return Padding(
                    padding: const EdgeInsets.only(top: 7),
                    child: Text(
                      text,
                      style: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 8.5,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => const Color(0xFF11182D),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 5.5),
                FlSpot(1, 3.1),
                FlSpot(2, 1.1),
                FlSpot(3, 1.5),
                FlSpot(4, 1.9),
                FlSpot(5, 2.0),
                FlSpot(6, 2.5),
                FlSpot(7, 3.0),
                FlSpot(8, 3.5),
                FlSpot(9, 0.8),
                FlSpot(10, 3.0),
                FlSpot(11, 3.2),
                FlSpot(12, 3.0),
                FlSpot(13, 0.9),
                FlSpot(14, 5.0),
                FlSpot(15, 5.1),
                FlSpot(16, 4.8),
                FlSpot(17, 1.5),
                FlSpot(18, 4.2),
                FlSpot(19, 2.4),
                FlSpot(20, 2.4),
                FlSpot(21, 4.7),
                FlSpot(22, 1.2),
                FlSpot(23, 1.2),
                FlSpot(24, 1.2),
                FlSpot(25, 3.8),
                FlSpot(26, 3.6),
                FlSpot(27, 4.5),
                FlSpot(28, 3.8),
              ],
              isCurved: true,
              curveSmoothness: 0.25,
              color: brightPurple,
              barWidth: 2.5,
              dotData: const FlDotData(
                show: false,
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    brightPurple.withValues(alpha: 0.22),
                    brightPurple.withValues(alpha: 0.02),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectPerformance() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        22,
        18,
        22,
        18,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 27,
                height: 27,
                decoration: BoxDecoration(
                  color: const Color(0xFF20124C),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.track_changes_rounded,
                  color: brightPurple,
                  size: 17,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Subject Performance',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _buildSubjectRow(
            name: 'Data Structures',
            percentage: 80,
            color: brightPurple,
          ),
          const SizedBox(height: 17),
          _buildSubjectRow(
            name: 'Calculus II',
            percentage: 75,
            color: pink,
          ),
          const SizedBox(height: 17),
          _buildSubjectRow(
            name: 'Web Development',
            percentage: 67,
            color: const Color(0xFF10B981),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectRow({
    required String name,
    required double percentage,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 145,
          child: Text(
            name,
            style: const TextStyle(
              color: Color(0xFFE2E8F0),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                Container(
                  height: 7,
                  color: const Color(0xFF171E31),
                ),
                FractionallySizedBox(
                  widthFactor: percentage / 100,
                  child: Container(
                    height: 7,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 18),
        const SizedBox(
          width: 75,
          child: Text(
            '0 tasks done',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: mutedText,
              fontSize: 10,
            ),
          ),
        ),
        const SizedBox(width: 17),
        SizedBox(
          width: 35,
          child: Text(
            '${percentage.toInt()}%',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductivityScore(bool isMobile) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        22,
        18,
        22,
        18,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.emoji_events_outlined,
                color: Color(0xFF67E8F9),
                size: 19,
              ),
              const SizedBox(width: 10),
              const Text(
                'Productivity Score',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (isMobile)
            Column(
              children: [
                _buildScoreGauge(),
                const SizedBox(height: 16),
                _buildProductivityTiles(true),
              ],
            )
          else
            Row(
              children: [
                SizedBox(
                  width: 185,
                  child: _buildScoreGauge(),
                ),
                const SizedBox(width: 25),
                Expanded(
                  child: _buildProductivityTiles(false),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildScoreGauge() {
    return SizedBox(
      height: 145,
      child: Center(
        child: SizedBox(
          width: 120,
          height: 120,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  startDegreeOffset: -90,
                  sectionsSpace: 0,
                  centerSpaceRadius: 45,
                  sections: [
                    PieChartSectionData(
                      value: 78,
                      color: brightPurple,
                      radius: 11,
                      showTitle: false,
                    ),
                    PieChartSectionData(
                      value: 22,
                      color: const Color(0xFF1A2036),
                      radius: 11,
                      showTitle: false,
                    ),
                  ],
                ),
              ),
              const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '78',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 1),
                  Text(
                    '/100',
                    style: TextStyle(
                      color: mutedText,
                      fontSize: 11,
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

  Widget _buildProductivityTiles(bool mobile) {
    final tiles = [
      _ProductivityData(
        title: 'Goal Completion',
        value: '0%',
      ),
      _ProductivityData(
        title: 'Tasks Completed',
        value: '0',
      ),
      _ProductivityData(
        title: 'Missed Tasks',
        value: '0',
      ),
      _ProductivityData(
        title: 'Study Streak',
        value: '7 days',
        highlighted: true,
      ),
    ];

    if (mobile) {
      return Column(
        children: [
          for (int i = 0; i < tiles.length; i++) ...[
            _buildProductivityTile(tiles[i]),
            if (i != tiles.length - 1)
              const SizedBox(height: 10),
          ],
        ],
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildProductivityTile(tiles[0]),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildProductivityTile(tiles[1]),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildProductivityTile(tiles[2]),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildProductivityTile(tiles[3]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProductivityTile(
    _ProductivityData data,
  ) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: cardColor2,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: const Color(0xFF1B263E),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            data.title,
            style: const TextStyle(
              color: mutedText,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            data.value,
            style: TextStyle(
              color: data.highlighted
                  ? brightPurple
                  : Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryData {
  const _SummaryData({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.subtitleColor,
    required this.icon,
  });

  final String title;
  final String value;
  final String? subtitle;
  final Color? subtitleColor;
  final IconData icon;
}

class _ProductivityData {
  const _ProductivityData({
    required this.title,
    required this.value,
    this.highlighted = false,
  });

  final String title;
  final String value;
  final bool highlighted;
}