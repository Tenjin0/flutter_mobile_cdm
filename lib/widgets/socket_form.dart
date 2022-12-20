import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cdm_mobile/controllers/cdm_url.dart';

class SocketForm extends StatefulWidget {
  final Function onValidate;
  const SocketForm({Key? key, required this.onValidate}) : super(key: key);

  @override
  _SocketFormState createState() => _SocketFormState();
}

class _SocketFormState extends State<SocketForm> {
  final CDMURLCtrl cdmUrl = Get.find<CDMURLCtrl>();

  final formKey = GlobalKey<FormState>();
  final TextEditingController hostnameCtrl =
      TextEditingController(text: "192.168.0.8");
  final TextEditingController portCtrl = TextEditingController(text: "3000");
  final TextEditingController namespaceCtrl =
      TextEditingController(text: 'mobile_1');

  void initState() {
    // hostnameCtrl.text = cdmUrl.url.value.hostname;
    // portCtrl.text = cdmUrl.url.value.port.toString();
    // namespaceCtrl.text = cdmUrl.url.value.namespace;
    super.initState();
  }

  void dispose() {
    hostnameCtrl.dispose();
    portCtrl.dispose();
    namespaceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'CDM CONNECTION',
                style: TextStyle(fontSize: 30, color: Color(0xFF363f93)),
              ),
            ),
            SizedBox(
              height: height * 0.04,
            ),
            TextFormField(
              controller: hostnameCtrl,
              decoration:
                  const InputDecoration(label: Text("Enter the hostname")),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter correct hostname';
                } else {
                  return null;
                }
              },
            ),
            SizedBox(
              height: height * 0.04,
            ),
            TextFormField(
              controller: portCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(label: Text("Enter the port")),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter correct port';
                } else {
                  return null;
                }
              },
            ),
            SizedBox(
              height: height * 0.04,
            ),
            TextFormField(
              controller: namespaceCtrl,
              decoration:
                  const InputDecoration(label: Text("Enter the namespace")),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter correct namespace';
                } else {
                  return null;
                }
              },
            ),
            SizedBox(
              height: height * 0.04,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 120.0,
                  height: 40.0,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        widget.onValidate(hostnameCtrl.text,
                            int.parse(portCtrl.text), namespaceCtrl.text);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      // fixedSize: Size(100.0, 30.0),
                      textStyle: const TextStyle(
                        fontSize: 20,
                      ),
                      elevation: 3,
                    ),
                    child: const Text('Connect'),
                  ),
                ),

                // TextButton(
                //   child: Icon(
                //     Icons.arrow_right,
                //     // color: Colors.white,
                //   ),
                //   onPressed: () {
                //     if (formKey.currentState!.validate()) {
                //       this.widget.onValidate(
                //           hostnameCtrl.text, portCtrl.text, namespaceCtrl.text);
                //     }
                //   },
                // )
              ],
            )
          ],
        ),
      ),
    );
  }
}
