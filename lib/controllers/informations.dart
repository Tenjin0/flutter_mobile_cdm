import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../models/informations.dart';

class InformationsCtrl extends GetxController {
  final info = Informations("unknown", "unknown", "0.0.0").obs;

  replace(Informations i) {
    info.update((thisInfo) {
      thisInfo?.name = i.name;
      thisInfo?.id = i.id;
      thisInfo?.version = i.version;
    });
  }

  register(num id) {
    info.update((thisInfo) {
      thisInfo?.register = id;
    });
  }
}
