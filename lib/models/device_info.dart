import 'package:uuid/uuid.dart';

class DeviceInfo {
  late String id;

  DeviceInfo(String? id) {
    if (id != null) {
      this.id = id;
    } else {
      const uuid = Uuid();
      this.id = uuid.v4();
    }
  }

  static generate() {
    const uuid = Uuid();
    return DeviceInfo(uuid.v4());
  }
}
