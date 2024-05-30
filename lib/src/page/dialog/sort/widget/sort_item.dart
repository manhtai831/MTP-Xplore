import 'package:device_explorer/src/common/widgets/base_button.dart';
import 'package:device_explorer/src/common/widgets/base_text.dart';
import 'package:device_explorer/src/model/sort_model.dart';
import 'package:flutter/material.dart';

class SortItem extends StatelessWidget {
  const SortItem({super.key, this.sort, this.onChange, this.current});
  final SortModel? sort;
  final SortModel? current;
  final VoidCallback? onChange;
  @override
  Widget build(BuildContext context) {
    return BaseButton(
      onPressed: onChange,
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Radio<SortModel>(
              value: sort!,
              groupValue: current,
              onChanged: _onChange,
            ),
            Image.asset(
              sort?.icon ?? '',
              width: 24,
            ),
            const SizedBox(width: 16),
            BaseText(
              title: sort?.name,
              fontWeight: current == sort ? FontWeight.bold : null,
              color: current == sort ? Theme.of(context).primaryColor : null,
            )
          ],
        ),
      ),
    );
  }

  void _onChange(SortModel? value) {
    onChange?.call();
  }
}
