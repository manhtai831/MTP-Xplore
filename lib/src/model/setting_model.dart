class SettingModel {
  /// app setting sort
  int? sortId;

  bool? showHiddenFile;

  String? langCode;
  SettingModel({
    this.sortId,
    this.showHiddenFile,
    this.langCode,
  });

  SettingModel.fromJson(Map<String, dynamic> json) {
    sortId = json['sort_id']?.toInt() as int?;
    showHiddenFile = json['show_hidden_file'] as bool?;
    langCode = json['lang_code'] as String?;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'sort_id': sortId,
      'show_hidden_file': showHiddenFile,
      'lang_code': langCode,
    };
  }

  SettingModel copyWith({
    int? sortId,
    bool? showHiddenFile,
    String? langCode,
  }) {
    return SettingModel(
      sortId: sortId ?? this.sortId,
      showHiddenFile: showHiddenFile ?? this.showHiddenFile,
      langCode: langCode ?? this.langCode,
    );
  }
}
