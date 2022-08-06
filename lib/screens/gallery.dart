import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scan/scan.dart';
import 'package:url_launcher/url_launcher.dart';

_getFromGallery() async {
  PickedFile? pickedFile = await ImagePicker().getImage(
    source: ImageSource.gallery,
    maxWidth: 1800,
    maxHeight: 1800,
  );
  if (pickedFile != null) {
    return pickedFile.path;
  }
}

open(pic) async {
  if (pic != null) {
    String? url = await Scan.parse(pic!.path);
    if (url != null) {
      launch(url.toString());
    }
    pic = null;
  }
}

gallery(context) async {
  var path = await _getFromGallery();
  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      backgroundColor: Colors.white,
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(width: 200.0, height: 200.0, child: Image.file(File(path))),
        ],
      ),
      actions: <Widget>[
        new ElevatedButton(
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(5),
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                elevation: 0.0),
            onPressed: () {
              open(File(path));
              Navigator.of(context).pop();
            },
            child: Text("Go to URL (if any)")),
      ],
    ),
  );
}
