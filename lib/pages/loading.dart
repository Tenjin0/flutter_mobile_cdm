import 'package:cdm_mobile/controllers/informations.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../models/device_info.dart';
import '../models/informations.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  Future<DeviceInfo> init(TargetPlatform platform) async {
    switch (platform) {
      case TargetPlatform.android:
        DeviceInfoPlugin dip = DeviceInfoPlugin();
        return dip.androidInfo.then((ai) {
          return DeviceInfo(ai.id);
        });

      case TargetPlatform.linux:
        DeviceInfoPlugin dip = DeviceInfoPlugin();

        if (kIsWeb) {
          return dip.webBrowserInfo.then((wbi) {
            return DeviceInfo(wbi.productSub);
          });
        } else {
          return dip.linuxInfo.then((ldi) {
            return DeviceInfo(ldi.machineId);
          });
        }
      case TargetPlatform.windows:
        DeviceInfoPlugin dip = DeviceInfoPlugin();
        if (kIsWeb) {
          return dip.webBrowserInfo.then((wbi) {
            return DeviceInfo(wbi.productSub);
          });
        } else {
          return dip.windowsInfo.then((ldi) {
            return DeviceInfo(ldi.computerName);
          });
        }
      case TargetPlatform.iOS:
        DeviceInfoPlugin dip = DeviceInfoPlugin();
        if (kIsWeb) {
          return dip.webBrowserInfo.then((wbi) {
            return DeviceInfo(wbi.productSub);
          });
        } else {
          return dip.macOsInfo.then((ldi) {
            return DeviceInfo(ldi.computerName);
          });
        }
      default:
    }
    return DeviceInfo.generate();
  }

  @override
  Widget build(BuildContext context) {
    init(Theme.of(context).platform).then((deviceInfo) {
      PackageInfo.fromPlatform().then((packageInfo) {
        Informations newInfo = Informations(
            packageInfo.appName, deviceInfo.id, packageInfo.version);
        Get.find<InformationsCtrl>().replace(newInfo);

        Navigator.pushReplacementNamed(context, '/home');
      });
    });
    return const Scaffold(
        backgroundColor: Colors.blueGrey,
        body: Center(
          child: SpinKitCubeGrid(
            color: Color.fromRGBO(255, 255, 255, 1),
            size: 50,
          ),
        ));
  }
}
