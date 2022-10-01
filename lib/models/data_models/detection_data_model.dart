class DetectionDataModel {
  final int detectionId;
  final double accuracy;
  final String label;
  DetectionDataModel(this.accuracy, this.label, {this.detectionId = 0});

  Map<String, Object?> toMap() {
    return <String, Object?>{
      "accuracy": accuracy,
      "label": label
    };
  }
}
