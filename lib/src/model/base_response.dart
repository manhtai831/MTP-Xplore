import 'dart:io';

import 'package:process_run/shell.dart';

typedef FromString<T> = T Function(Iterable<String>);

class BaseResponse<T> {
  List<ProcessResult>? raw;
  String? error;
  T? data;

  BaseResponse.fromData(List<ProcessResult>? data,
      {FromString<T>? fromString}) {
    raw = data;
    error = data?.errText;

    if (data?.outLines != null) {
      this.data = fromString?.call(data!.outLines);
    } else {
      this.data = data?.outLines as T;
    }
  }
}
