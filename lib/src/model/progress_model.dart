class ProgressModel {
  /// length in bytes
  double? total;
  double? count;
  String? toPath;
  String? fromPath;

  ProgressModel({
    this.total,
    this.count,
    this.fromPath,
    this.toPath,
  });

  String getStatusText() {
    return 'Pulling: [${(getProgress() * 100).toInt()}%] $fromPath --> $toPath';
  }

  double getProgress() {
    return (count ?? 0) / (total ?? 1);
  }
}
