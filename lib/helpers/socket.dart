import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cdm_mobile/controllers/informations.dart';
import 'package:get/get.dart';
import 'package:cdm_mobile/controllers/cdm_url.dart';
import 'package:cdm_mobile/controllers/informations.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:screenshot/screenshot.dart';

socketFactory(String ip) {
  final InformationsCtrl globalInfo = Get.find<InformationsCtrl>();
  final ScreenshotController screenshotCtrl = Get.find<ScreenshotController>();

  print(ip);
  IO.Socket socket = IO.io(
      ip,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .disableReconnection()
          .build());

  socket.on('central.init', (data) {
    socket.emit("central.init", {
      "id": globalInfo.info.value.id,
      "name": globalInfo.info.value.name,
      "version": globalInfo.info.value.version,
    });
  });
  socket.on('infos', (data) {
    print("infos $data");

    socket.emit('infos', {
      "hardwareserial": globalInfo.info.value.id,
      "version": globalInfo.info.value.version
    });
  });

  socket.on('configuration.get', (data) {
    print("configuration.get $data");

    const configurations = {
      "inputs": {
        "documentation": "The inputs manager for WyndPOSTools",
        "fullkey": "inputs",
        "min": null,
        "max": null,
        "limits": null,
        "regex": null,
        "type": "object",
        "content": {
          "enable": {
            "documentation": "Enable/disable the plugin",
            "fullkey": "inputs.enable",
            "min": null,
            "max": null,
            "limits": null,
            "regex": null,
            "type": "boolean",
            "value": true
          }
        }
      },
    };
    if (data != null) {
      socket.emit('configuration.get', [data, configurations]);
    } else {
      socket.emit('configuration.get', [configurations]);
    }
  });
  socket.on('plugins', (data) {
    print("plugins $data");
    var plugins = [
      {
        "name": "Inputs",
        "version": "1.1.0",
        "description": "The inputs manager for WyndPOSTools",
        "authors": ["Sébastien VIDAL"],
        "enabled": true,
        "core": false,
        "windowsOnly": false,
        "depends": [],
        "dependencies": [],
        "unmaintainable": false
      },
    ];

    socket.emit('plugins', [plugins]);
  });
  socket.on('central.init.ack', (id) {
    globalInfo.register(id);
  });

  socket.on(
      "inputs.screenshot",
      (data) => {
            screenshotCtrl.captureAsUiImage().then((ui.Image? image) async {
              if (image != null) {
                ByteData? byteData =
                    await image.toByteData(format: ui.ImageByteFormat.png);
                var pngBytes = byteData!.buffer.asUint8List();
                String base64string = base64.encode(pngBytes);
                print('capture done $data');
                socket.emit("inputs.screenshot", [
                  {"type": "bytes", "data": pngBytes}
                ]);
              } else {
                var err = {"code": "NO_IMAGE", "message": "no image generated"};
                socket.emit("inputs.screenshot.error", err);
              }
            }).catchError((onError) {
              socket.emit("inputs.screenshot.error",
                  {"code": "NO_IMAGE", "message": onError});
              print(onError);
            })
          });

  return socket;
}
