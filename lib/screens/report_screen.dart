import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pry_20220140/constants/global.dart';
import 'package:pry_20220140/database/database_helper.dart';
import 'package:pry_20220140/models/data_models/report_data_model.dart';
import 'package:pry_20220140/models/view_models/circular_report_view_model.dart';

class ReportScreen extends StatefulWidget {
  final DateTime selectedDatetime;
  const ReportScreen(this.selectedDatetime, {Key? key}) : super(key: key);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  Future? _getDataFuture;

  @override
  void initState() {
    super.initState();
    _getDataFuture = _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(alignment: Alignment.centerLeft, child: Text("Reportes")),
          FutureBuilder(
              future: _getDataFuture,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Container(
                    child: Text("Ocurrió un error"),
                  );
                }

                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return Column(
                    children: _buildCircularProgress(
                        (snapshot.data as List<CircularReportViewModel>)),
                  );
                }
                return Container(
                  child: CircularProgressIndicator(),
                );
              })
        ],
      ),
    );
  }

  List<Widget> _buildCircularProgress(
      List<CircularReportViewModel> circularReportViewModelList) {
    List<Widget> circularProgressList = [];
    for (var circularReportViewModel in circularReportViewModelList) {
      circularProgressList.add(Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: CircularPercentIndicator(
          circularStrokeCap: CircularStrokeCap.round,
          radius: 120.0,
          lineWidth: 15.0,
          center: new Text(
              (circularReportViewModel.accuracy * 100).toStringAsFixed(2) + "%",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              )),
          percent: circularReportViewModel.accuracy,
          backgroundColor: Colors.white,
          progressColor: circularReportViewModel.color,
          footer: new Text(
            circularReportViewModel.label,
            style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
          ),
        ),
      ));
    }

    return circularProgressList;
  }

  Future<List<CircularReportViewModel>> _getData() async {
    // double percent = 0.0;
    try {
      var summary =
          await DatabaseHelper.instance.getSummary(widget.selectedDatetime);

      var total = summary
          .map((x) => x.total)
          .reduce((value, element) => value + element);

      var safeDriving = summary.firstWhere(
          (element) => element.label == Global.SAFE_DRIVING,
          orElse: () => DetectionTotalModel.defaultInstance());

      var notSafeDriving = summary.firstWhere(
          (element) => element.label != Global.SAFE_DRIVING,
          orElse: () => DetectionTotalModel.defaultInstance());

      return [
        CircularReportViewModel(safeDriving.total / total, "Conducción segura",
            color: Colors.green),
        CircularReportViewModel(
            notSafeDriving.total / total, "Conducción no segura")
      ];
      // percent = 1.0 - (safeDriving.total / total);
      // await DatabaseHelper.instance.getAll();
    } catch (e) {}

    return [];
  }
}
