import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:popup_window/popup_window.dart';

String link = "";
final linkController = TextEditingController();
var dataKey = GlobalKey<FormState>();
late XFile qrCode;

Widget generator(BuildContext context) {
  return new AlertDialog(
    backgroundColor: Colors.white,
    title: Text("Enter URL:"),
    content: Form(
      key: dataKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return ("URL can't be empty");
                } else {
                  return null;
                }
              },
              controller: linkController,
              onChanged: (value) {
                link = value;
              },
              decoration: InputDecoration(
                  hintText: "URL",
                  labelText: "Enter a URL to generate QR code"),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                textStyle:
                    TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            onPressed: () {
              dataKey.currentState!.validate() == false
                  ? Container()
                  : showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          _buildPopupDialog(context),
                    );
              linkController.clear();
            },
            child: Text("Generate QR"),
          ),
        ],
      ),
    ),
  );
}

Widget _buildPopupDialog(BuildContext context) {
  return new AlertDialog(
    backgroundColor: Colors.white,
    title: Text(link),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 200.0,
          height: 200.0,
          child: QrImage(
            errorStateBuilder: (context, error) => Text(error.toString()),
            data: link,
          ),
        ),
      ],
    ),
    actions: <Widget>[
      new ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              padding: EdgeInsets.all(5),
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              elevation: 0.0),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.close)),
    ],
  );
}
