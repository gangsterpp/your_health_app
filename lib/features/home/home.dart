import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:your_health_app/controllers/health_controller.dart';
import 'package:your_health_app/core/di/app_container.dart';
import 'package:your_health_app/features/home/chart_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final HealthController healthController = AppContainer.of<HealthController>(context)..fetchHealth();

  @override
  void dispose() {
    healthController.dispose();
    super.dispose();
  }

  String dateFormate(String value) {
    final f = DateFormat('yyyy-mm-dd').parse(value);
    return DateFormat('d MMM', 'ru_RU').format(f).replaceAll('.', '');
  }

  Color parseValue(double value) {
    return value >= 2.8 ? Color(0xFF27A474) : Color(0xFFFFA100);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(),
        ),
        body: SafeArea(
            minimum: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: ListenableBuilder(
              listenable: healthController,
              builder: (context, child) {
                return switch (healthController.state) {
                  Loaded state => RefreshIndicator.adaptive(
                      onRefresh: healthController.fetchHealth,
                      child: CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            child: Text(
                              'Dynamics',
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                fontWeight: FontWeight.w600,
                                fontSize: 32,
                                height: 38 / 32,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Text(
                              'All Period',
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.fade,
                              style: GoogleFonts.manrope(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                height: 20 / 16,
                                color: Color(0xFF828282),
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(child: SizedBox(height: 20)),
                          SliverToBoxAdapter(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16), // Закругление углов контейнера
                              child: ChartWidget(
                                values: state.data.values,
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(child: SizedBox(height: 20)),
                          SliverList.separated(
                            itemCount: state.data.alerts.length,
                            itemBuilder: (_, index) {
                              return DecoratedBox(
                                decoration: BoxDecoration(color: Color(0xFFF9FAFF)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    spacing: 12,
                                    children: [
                                      Text(
                                        state.data.alerts[index].message,
                                      ),
                                      if (state.data.alerts[index].resubmitLink)
                                        Text.rich(
                                          style: TextStyle(color: Color(0xFF005EFF)),
                                          TextSpan(
                                              text: 'Resubmit the markers',
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  print('Resubmit requested');
                                                }),
                                        )
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (BuildContext context, int index) {
                              return SizedBox(height: 20);
                            },
                          ),
                          SliverToBoxAdapter(child: SizedBox(height: 20)),
                          SliverList.separated(
                            itemCount: state.data.values.length + 2,
                            itemBuilder: (_, index) {
                              // Дата и ME
                              if (index == 0) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Дата',
                                      style: GoogleFonts.manrope(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        height: 16 / 12,
                                        color: Color(0xFFB0B0B0),
                                      ),
                                    ),
                                    Text(
                                      'ME/мл',
                                      style: GoogleFonts.manrope(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        height: 16 / 12,
                                        color: Color(0xFFB0B0B0),
                                      ),
                                    ),
                                  ],
                                );
                              }

                              // Самый последний DIVIDER чтобы отображался по дизигну
                              if (index == state.data.values.length + 1) {
                                return SizedBox.shrink();
                              }
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    spacing: 11,
                                    children: [
                                      Text(
                                        dateFormate(state.data.values[index - 1].date),
                                        overflow: TextOverflow.fade,
                                        style: TextStyle(
                                          fontFamily: 'Gilroy',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 24,
                                          height: 26 / 24,
                                          color: Color(0xFF1A1A1A),
                                        ),
                                      ),
                                      Text(
                                        state.data.values[index - 1].lab,
                                        overflow: TextOverflow.fade,
                                        style: GoogleFonts.manrope(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          height: 27 / 14,
                                          color: Color(0xFF828282),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${state.data.values[index - 1].value}',
                                    style: TextStyle(
                                      color: parseValue(state.data.values[index - 1].value),
                                      overflow: TextOverflow.fade,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 28,
                                      height: 32 / 28,
                                    ),
                                  ),
                                ],
                              );
                            },
                            separatorBuilder: (BuildContext context, int index) {
                              return Divider();
                            },
                          ),
                        ],
                      ),
                    ),
                  ErrorState state => Stack(
                      children: [
                        Center(child: Text(state.message)),
                      ],
                    ),
                  _ => Stack(
                      children: [
                        Center(child: CircularProgressIndicator.adaptive()),
                      ],
                    )
                };
              },
            )));
  }
}
