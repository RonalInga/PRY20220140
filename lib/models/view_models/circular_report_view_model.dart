import 'dart:ui';

class CircularReportViewModel {
  final double accuracy;
  final String label;
  final Color color;
  CircularReportViewModel(this.accuracy, this.label,
      {this.color = const Color.fromARGB(255, 255, 0, 0)});
}
