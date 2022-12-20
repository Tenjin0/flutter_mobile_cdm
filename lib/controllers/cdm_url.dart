import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../models/cdm_url.dart';

class CDMURLCtrl extends GetxController {
  final url = CDMUrl("", 80, "").obs;

  void replace(CDMUrl newUrl) {
    url.update((thisUrl) {
      thisUrl!.hostname = newUrl.hostname;
      thisUrl.port = newUrl.port;
      thisUrl.namespace = newUrl.namespace;
    });
  }
}
