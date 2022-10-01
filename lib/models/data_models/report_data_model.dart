class DetectionTotalModel {
  final String label;
  final int total;

  DetectionTotalModel(this.label, this.total);

  static DetectionTotalModel defaultInstance() {
    return DetectionTotalModel("", 0);
  }
}
