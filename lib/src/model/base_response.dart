import 'dart:developer';
import 'dart:io';

typedef FromString<T> = T Function(String);

class BaseResponse<T> {
  String? raw;
  int? code;
  T? data;

  BaseResponse.success(
    String? data, {
    FromString<T>? fromString,
  }) {
    raw = data;
    code = 0;

    if (raw != null) {
      this.data = fromString?.call(raw!);
    } else {
      this.data = data as T?;
    }
  }

  BaseResponse.error(
    String? data, {
    int? code,
    FromString<T>? fromString,
  }) {
    raw = data;
    code = code ?? 1;

    if (raw != null) {
      this.data = fromString?.call(raw!);
    } else {
      this.data = data as T?;
    }
  }
  BaseResponse.fromProcess(
    ProcessResult data, {
    int? code,
    FromString<T>? fromString,
  }) {
    if (data.stdout != null) {
      raw = data.stdout;
      code = 0;
      if (raw != null) {
        this.data = fromString?.call(raw!);
      } else {
        this.data = raw as T?;
      }
    } else if (data.stderr != null) {
      raw = data.stderr;
      code = code ?? 1;
    }
    // log('${DateTime.now()}  raw: \n$raw',name: 'VERBOSE');
  }

  bool isOke()=> code == 0;
}
