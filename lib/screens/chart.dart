import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:ekhata/bloc/auth_bloc.dart';
import 'package:ekhata/bloc/auth_state.dart';
import '../services/storage_service.dart';
import '../services/dashboard.dart';
import 'user/profile.dart';
import 'search.dart';
import './transaction/transactions_list.dart';

class ChartData {
  ChartData(this.x, this.y, [this.color]);
  final String x;
  final double y;
  final Color? color;
}

class Chart extends StatefulWidget {
  const Chart({Key? key}) : super(key: key);
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  List<Map<String, dynamic>> transactions = [];

  List<ChartData> income7Days = [];
  List<ChartData> income15Days = [];
  List<ChartData> income30Days = [];

  List<ChartData> expense7Days = [];
  List<ChartData> expense15Days = [];
  List<ChartData> expense30Days = [];

  Future<void> getData() async {
    List response = await DashboardService.getChartData();
    if (response[0] == true) {
      income7Days = [];
      income15Days = [];
      income30Days = [];

      expense7Days = [];
      expense15Days = [];
      expense30Days = [];
      Map day7 = response[1]["day7"];
      Map day15 = response[1]["day15"];
      Map day30 = response[1]["day30"];
      print(day7);

      setState(() {
        day7["expense"].forEach((key, value) {
          expense7Days.add(ChartData(key, value));
        });
        day15["expense"].forEach((key, value) {
          expense15Days.add(ChartData(key, value));
        });
        day30["expense"].forEach((key, value) {
          expense30Days.add(ChartData(key, value));
        });
        day7["income"].forEach((key, value) {
          print("$key $value");
          income7Days.add(ChartData(key, value));
        });
        day15["income"].forEach((key, value) {
          income15Days.add(ChartData(key, value));
        });
        day30["income"].forEach((key, value) {
          income30Days.add(ChartData(key, value));
        });
      });
    } else {
      // showSnackBar(false);
    }
  }

  late TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AuthBloc(),
        child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
          return Column(children: [
            SizedBox(height: 20),
            // ElevatedButton(
            //     onPressed: () {
            //       print("get");
            //       getData();
            //     },
            //     child: Text("Button")),
            Container(
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  color: Colors.black,
                  width: 2.0, // This would be the width of the underline
                ))),
                child: const Text("Income",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ))),
            SizedBox(height: 20),
            Container(
                height: 300,
                child: DefaultTabController(
                  length: 3,
                  child: Scaffold(
                    appBar: AppBar(
                      toolbarHeight: 0,
                      shape: Border(bottom: BorderSide(color: Colors.grey)),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      bottom: TabBar(
                        labelColor: Theme.of(context).primaryColor,
                        unselectedLabelColor: Colors.black,
                        tabs: const [
                          FittedBox(
                            child: Text("Last 7 days"),
                          ),
                          FittedBox(
                            child: Text(
                              "Last 15 Days",
                              textAlign: TextAlign.center,
                            ),
                          ),
                          FittedBox(
                            child: Text(
                              "Last 30 Days",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    body: TabBarView(
                      children: [
                        ...[income7Days, income15Days, income30Days].map<Widget>((data) {
                          return Container(
                              child: SfCircularChart(
                                  tooltipBehavior: _tooltipBehavior,
                                  legend: Legend(isVisible: true),
                                  series: <CircularSeries>[
                                PieSeries<ChartData, String>(
                                    enableTooltip: true,
                                    dataSource: data,
                                    xValueMapper: (ChartData data, _) => data.x,
                                    yValueMapper: (ChartData data, _) => data.y,
                                    dataLabelSettings: DataLabelSettings(isVisible: true))
                              ]));
                        }).toList(),
                      ],
                    ),
                  ),
                )),
            SizedBox(height: 20),
            Container(
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  color: Colors.black,
                  width: 2.0, // This would be the width of the underline
                ))),
                child: const Text("Expense",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ))),
            SizedBox(height: 20),
            Container(
                height: 300,
                child: DefaultTabController(
                  length: 3,
                  child: Scaffold(
                    appBar: AppBar(
                      toolbarHeight: 0,
                      shape: Border(bottom: BorderSide(color: Colors.grey)),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      bottom: TabBar(
                        labelColor: Theme.of(context).primaryColor,
                        unselectedLabelColor: Colors.black,
                        tabs: const [
                          FittedBox(
                            child: Text("Last 7 days"),
                          ),
                          FittedBox(
                            child: Text(
                              "Last 15 Days",
                              textAlign: TextAlign.center,
                            ),
                          ),
                          FittedBox(
                            child: Text(
                              "Last 30 Days",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    body: TabBarView(
                      children: [
                        ...[expense7Days, expense15Days, expense30Days].map<Widget>((data) {
                          return Container(
                              child: SfCircularChart(
                                  tooltipBehavior: _tooltipBehavior,
                                  legend: Legend(isVisible: true),
                                  series: <CircularSeries>[
                                PieSeries<ChartData, String>(
                                    enableTooltip: true,
                                    dataSource: data,
                                    xValueMapper: (ChartData data, _) => data.x,
                                    yValueMapper: (ChartData data, _) => data.y,
                                    dataLabelSettings: DataLabelSettings(isVisible: true))
                              ]));
                        }).toList(),
                      ],
                    ),
                  ),
                )),
          ]);
        }));
  }
}
