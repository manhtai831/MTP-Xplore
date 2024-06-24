class PackageRepository {
  PackageRepository._();

  static final PackageRepository _singleton = PackageRepository._();

  factory PackageRepository() => _singleton;

  Future<void> installApk(String? path) async {}
  Future<void> uninstallApk(String? packageName) async {}
  Future<void> getPackages() async {}
  Future<void> screenCap() async {}
  Future<void> screenRecord() async {}
}
