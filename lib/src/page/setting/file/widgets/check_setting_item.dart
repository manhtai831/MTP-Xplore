import 'package:device_explorer/src/common/widgets/base_button.dart';
import 'package:device_explorer/src/common/widgets/base_text.dart';
import 'package:flutter/material.dart';

typedef OnCheckedChange = void Function(bool);

class CheckSettingItem extends StatefulWidget {
  const CheckSettingItem(
      {super.key, this.title, this.onChange, this.defaultCheck});
  final String? title;
  final OnCheckedChange? onChange;
  final bool? defaultCheck;

  @override
  State<CheckSettingItem> createState() => _CheckSettingItemState();
}

class _CheckSettingItemState extends State<CheckSettingItem> {
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    isChecked = widget.defaultCheck ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: BaseButton(
        borderRadius: BorderRadius.circular(8),
        onPressed: () => _onChange(!isChecked),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 16,
          ),
          child: Row(
            children: [
              Expanded(
                  child: BaseText.bold(
                title: widget.title,
              )),
              Checkbox(value: isChecked, onChanged: _onChange),
            ],
          ),
        ),
      ),
    );
  }

  void _onChange(bool? value) {
    isChecked = value ?? false;
    setState(() {});
    widget.onChange?.call(isChecked);
  }
}
