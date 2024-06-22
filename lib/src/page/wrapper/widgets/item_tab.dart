import 'package:device_explorer/src/common/widgets/base_button.dart';
import 'package:device_explorer/src/common/widgets/base_text.dart';
import 'package:device_explorer/src/model/tab_model.dart';
import 'package:flutter/material.dart';

class ItemTab extends StatelessWidget {
  const ItemTab({
    super.key,
    this.item,
    this.onPressed,
    this.onClosePressed,
    this.hasClose,
  });
  final TabModel? item;
  final bool? hasClose;
  final VoidCallback? onPressed;
  final VoidCallback? onClosePressed;
  @override
  Widget build(BuildContext context) {
    return BaseButton(
      onPressed: onPressed,
      child: Container(
        height: double.infinity,
        alignment: Alignment.center,
        width: 200,
        decoration: BoxDecoration(
          color: item?.isSelected == true ? Colors.white : Colors.black12,
          border: Border.all(
              color: item?.isSelected == true
                  ? Colors.transparent
                  : Colors.black12),
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: BaseText(
                title: item?.directory?.lastPath ?? 'Unknown',
                maxLines: 1,
              ),
            ),
            if (hasClose == true)
              BaseButton(
                onPressed: onClosePressed,
                child: const Icon(Icons.close_rounded),
              )
          ],
        ),
      ),
    );
  }
}
