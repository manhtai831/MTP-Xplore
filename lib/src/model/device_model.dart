class DeviceModel {
  // 102793736C000579       device usb:17825792X product:LH7n-GL model:TECNO_LH7n device:TECNO-LH7n transport_id:1
  String? id;
  String? type;
  String? usb;
  String? product;
  String? model;
  String? device;
  String? transportId;

  DeviceModel.fromString(String s) {

    Iterable<String> splits = s.split(' ').where((it)=> it.isNotEmpty);
    id = splits.elementAt(0);
    type = splits.elementAt(1);
    usb = splits.elementAt(2).split(':').elementAt(1);
    product = splits.elementAt(3).split(':').elementAt(1);
    model = splits.elementAt(4).split(':').elementAt(1);
    device = splits.elementAt(5).split(':').elementAt(1);
    transportId = splits.elementAt(6).split(':').elementAt(1);
  }
}
