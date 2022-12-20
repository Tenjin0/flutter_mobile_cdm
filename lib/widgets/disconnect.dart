import 'package:flutter/material.dart';

class DisconnectSocket extends StatelessWidget {
  final Function onDisconnect;
  const DisconnectSocket({Key? key, required this.onDisconnect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        width: double.maxFinite,
        child: ElevatedButton(
          onPressed: () {
            this.onDisconnect();
          },
          child: Text(
            'Disconnect',
          ),
          style: ElevatedButton.styleFrom(
            // fixedSize: Size(100.0, 30.0),
            textStyle: TextStyle(
              fontSize: 18,
            ),
            elevation: 3,
          ),
        ),
      ),
    );
  }
}
