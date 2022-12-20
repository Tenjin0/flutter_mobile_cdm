import 'package:flutter/material.dart';

class NotificationForm extends StatefulWidget {
  final Function onSend;
  const NotificationForm({Key? key, required this.onSend}) : super(key: key);

  @override
  _NotificationFormState createState() => _NotificationFormState();
}

class _NotificationFormState extends State<NotificationForm> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController notificationCtrl =
      TextEditingController(text: '');
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Container(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Notification",
                style: TextStyle(fontSize: 30, color: Color(0xFF363f93)),
              ),
            ),
            SizedBox(
              height: height * 0.04,
            ),
            TextFormField(
              controller: notificationCtrl,
              decoration: const InputDecoration(label: Text("Enter a message")),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter a message';
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
                        this.widget.onSend(notificationCtrl.text);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      // fixedSize: Size(100.0, 30.0),
                      textStyle: const TextStyle(
                        fontSize: 20,
                      ),
                      elevation: 3,
                    ),
                    child: const Text(
                      'Send',
                    ),
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
