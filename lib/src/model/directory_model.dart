class DirectoryModel {
  String? path;
  DirectoryModel? parent;

  DirectoryModel({
    this.path,
    this.parent,
  });

  void nexDir() {
    parent = this;
  }

  String? get lastPath => path?.split('/').lastOrNull;
}
