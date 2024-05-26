import 'package:device_explorer/src/common/base/base_provider.dart';
import 'package:device_explorer/src/page/detail/file_detail_page.dart';

class FileDetailProvider extends BaseProvider {
  FileDetailPageArgs? args;

  @override
  Future<void> init() async {
    args = getArguments();
  }
}
