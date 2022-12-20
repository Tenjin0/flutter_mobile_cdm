import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:cdm_mobile/controllers/cdm_url.dart';
import 'package:cdm_mobile/models/cdm_url.dart';
import 'package:cdm_mobile/widgets/disconnect.dart';
import 'package:cdm_mobile/widgets/notification.dart';
import 'package:cdm_mobile/widgets/socket_form.dart';
import 'package:cdm_mobile/helpers/socket.dart';

import 'package:screenshot/screenshot.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isConnected = false;

  @override
  void dispose() {
    if (socket != null && socket!.connected) {
      socket!.clearListeners();
      socket!.close();
    }
    super.dispose();
  }

  showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  onDisconnectClick() {
    if (socket != null) {
      if (socket!.connected) {
        socket?.disconnect();
      } else if (!isConnected) {
        setState(() {
          isConnected = false;
          socket = null;
        });
      }
    } else {
      setState(() {
        isConnected = false;
      });
    }
  }

  onValidateSocketForm(String hostname, int port, String namespace) {
    Get.find<CDMURLCtrl>().replace(CDMUrl(hostname, port, namespace));

    if (socket != null) {
      // print('socket creation');
      socket!.disconnect();
    }
    socket = socketFactory('http://$hostname:$port/$namespace');

    socket!.onConnect((data) {
      setState(() {
        isConnected = true;
      });
    });
    socket!.onConnectError((data) {
      setState(() {
        isConnected = false;
        socket = null;
      });
    });
    socket!.onDisconnect((_) {
      socket?.clearListeners();
      socket?.close();
      setState(() {
        isConnected = false;
        socket = null;
      });
    });

    socket!.onConnectError((data) {
      socket = null;
      showSnackBar(data.toString());
    });

    socket!.on('notification', (message) {
      socket?.emit('notification');
      if (message is String) {
        showSnackBar(message);
      } else if (message.containsKey("value")) {
        showSnackBar(message["value"]);
      }
    });

    socket!.on('central.message', (message) {
      print(message);
    });
    socket!.on('error', (dynamic err) {
      String message = err!.msg;
      showSnackBar(message);
    });
    socket!.connect();
  }

  onSend(String message) {
    print(message);
    if (socket!.connected) {
      socket?.emit('central.message', {
        "socket_id": null,
        "message": {
          "id": DateTime.now().millisecondsSinceEpoch,
          "event": "notification",
          "type": "REQUEST",
          "data": {"type": "info", "message": message}
        }
      });
    }
  }

  IO.Socket? socket;
  @override
  Widget build(BuildContext context) {
    final ScreenshotController screenshotCtrl = Get.put(ScreenshotController());

    // final InformationCrtl globalInfo = Get.find<InformationCrtl>();

    return Screenshot(
      controller: screenshotCtrl,
      child: Scaffold(
          appBar: AppBar(
            title: const Center(child: Text('CDM mobile app')),
          ),
          body: Container(
            padding: const EdgeInsets.all(10.0),
            child: isConnected
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      NotificationForm(
                        onSend: onSend,
                      ),
                      DisconnectSocket(onDisconnect: onDisconnectClick),
                    ],
                  )
                : SocketForm(
                    onValidate: onValidateSocketForm,
                  ),
          )),
    );
  }
}
