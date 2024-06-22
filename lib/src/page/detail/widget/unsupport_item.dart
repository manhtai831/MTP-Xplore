import 'package:device_explorer/src/common/widgets/base_text.dart';
import 'package:device_explorer/src/model/file_model.dart';
import 'package:flutter/material.dart';

class UnsupportItem extends StatelessWidget {
  const UnsupportItem({super.key, this.item});
  final FileModel? item;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: BaseText(
        title: 'Not support open: ${item?.name}',
        fontSize: 32,
        textAlign: TextAlign.center,
      ),
    );
  }
}
