import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:your_health_app/domain/value.dart';

class ChartWidget extends StatefulWidget {
  final List<Value> values;
  const ChartWidget({super.key, required this.values});

  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  bool showAvg = false;
  List<Value> values = [];
  int? selectedIndex;

  String dateFormate(String value) {
    final f = DateFormat('yyyy-mm-dd').parse(value);
    return DateFormat('d MMM yyyy', 'en_Eng').format(f).replaceAll('.', '');
  }

  @override
  void didChangeDependencies() {
    if (!identical(values, widget.values)) {
      values = widget.values;
    }
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant ChartWidget oldWidget) {
    if (!identical(values, widget.values)) {
      values = widget.values;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: LineChart(
        mainData(),
      ),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      clipData: FlClipData.horizontal(),
      titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value == 0.0) {
                  meta.max;
                  return Padding(
                    padding: EdgeInsets.only(left: 70), // Сдвигаем текст вправо
                    child: Text(
                      dateFormate(values.first.date),
                      style: TextStyle(
                        color: Color(0xFF040404).withAlpha((255 * 0.4).toInt()),
                        fontSize: 12,
                        height: 16 / 12,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else if (selectedIndex == value) {
                  return Text(
                    dateFormate(values[selectedIndex!].date),
                    style: TextStyle(
                      color: Color(0xFF040404).withAlpha((255 * 0.4).toInt()),
                      fontSize: 12,
                      height: 16 / 12,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          )),
      gridData: FlGridData(
        show: false,
        drawHorizontalLine: false,
        drawVerticalLine: false,
        verticalInterval: 0.1,
        horizontalInterval: 1,
      ),
      backgroundColor: Colors.white,
      borderData: FlBorderData(
        show: false,
      ),
      minX: 0,
      minY: 0,
      extraLinesData: ExtraLinesData(
        verticalLines: selectedIndex != null
            ? [
                VerticalLine(
                  x: selectedIndex!.toDouble(),
                  color: Colors.green,
                  strokeWidth: 1,
                  dashArray: [5, 5],
                ),
              ]
            : [],
      ),
      lineTouchData: LineTouchData(
        touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
          if (event.isInterestedForInteractions && response != null) {
            final spotIndex = response.lineBarSpots?.first.spotIndex;
            setState(() {
              selectedIndex = spotIndex;
            });
          }
        },
        handleBuiltInTouches: true,
      ),
      lineBarsData: [
        LineChartBarData(
          spots: [
            for (int i = 0; i < values.length; i++) FlSpot(i.toDouble(), values[i].value),
          ],
          isCurved: true,
          color: Color(0xFF69B137),
          barWidth: 2,
          isStrokeCapRound: true,
          belowBarData: BarAreaData(
            show: true,
            color: Color(0xFF69B137).withAlpha(25),
          ),
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, bar, index) {
              if (index == selectedIndex) {
                return FDotShadowCircle(
                  radius: 10, // Размер точки
                  shadowBlur: 4,
                  color: Colors.white, shadowColor: Color(0xFF286828).withAlpha((255 * 20 / 100).toInt()), // Цвет точки
                );
              }
              return FlDotCirclePainter(radius: 0); // Скрытые точки
            },
          ),
        ),
      ],
    );
  }
}

class FDotShadowCircle extends FlDotPainter {
  final double radius;
  final Color color;
  final Color shadowColor;
  final double shadowBlur;

  FDotShadowCircle({
    required this.radius,
    required this.color,
    required this.shadowColor,
    this.shadowBlur = 4.0,
  });

  @override
  void draw(Canvas canvas, FlSpot spot, Offset offsetInCanvas) {
    // Рисуем тень
    final shadowPaint = Paint()
      ..color = shadowColor.withAlpha((255 * 0.5).toInt())
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadowBlur); // Размытие

    canvas.drawCircle(
      offsetInCanvas.translate(0, 4), // Смещение тени вниз по Y
      radius, // Радиус тени
      shadowPaint,
    );

    final circlePaint = Paint()..color = color;
    canvas.drawCircle(
      offsetInCanvas, // Центральное положение круга
      radius, // Радиус круга
      circlePaint,
    );
  }

  @override
  Size getSize(FlSpot spot) {
    return Size(radius * 2, radius * 2);
  }

  @override
  FlDotPainter lerp(FlDotPainter a, FlDotPainter b, double t) {
    if (a is FDotShadowCircle && b is FDotShadowCircle) {
      return FDotShadowCircle(
        radius: lerpDouble(a.radius, b.radius, t) ?? radius,
        color: Color.lerp(a.color, b.color, t) ?? color,
        shadowColor: Color.lerp(a.shadowColor, b.shadowColor, t) ?? shadowColor,
        shadowBlur: lerpDouble(a.shadowBlur, b.shadowBlur, t) ?? shadowBlur,
      );
    }
    return this;
  }

  @override
  Color get mainColor => color;

  @override
  List<Object?> get props => [radius, color, shadowColor, shadowBlur];
}
