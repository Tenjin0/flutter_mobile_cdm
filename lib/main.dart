import 'package:cdm_mobile/controllers/cdm_url.dart';
import 'package:cdm_mobile/controllers/informations.dart';
import 'package:cdm_mobile/pages/home.dart';
import 'package:cdm_mobile/pages/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    final CDMURLCtrl cdmUrlCtrl = Get.put(CDMURLCtrl());
    final InformationsCtrl informationsCtrl = Get.put(InformationsCtrl());
    final ScreenshotController screenshotCtrl = Get.put(ScreenshotController());

    return MaterialApp(
        title: 'Flutter Demo',
        initialRoute: '/loading',
        routes: {
          '/loading': ((context) => const Loading()),
          '/home': ((context) => const Home())
        });
  }
}
