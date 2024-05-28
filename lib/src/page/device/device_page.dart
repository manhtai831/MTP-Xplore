import 'package:device_explorer/src/common/base/base_state.dart';
import 'package:device_explorer/src/model/device_model.dart';
import 'package:device_explorer/src/page/device/device_provider.dart';
import 'package:device_explorer/src/page/device/widgets/device_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DevicePage extends StatefulWidget {
  const DevicePage({super.key});

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends BaseState<DevicePage, DeviceProvider> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: provider,
      child: Scaffold(
        body: Consumer<DeviceProvider>(
          builder: (_, p, v) => Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[...provider.devices.map(_buildItem)],
          ),
        ),
      ),
    );
  }

  @override
  DeviceProvider get registerProvider => DeviceProvider();

  Widget _buildItem(DeviceModel e) {
    return DeviceItem(
      device: e,
      onPressed: ()=> provider.onItemPressed(e),
    );
  }
}
