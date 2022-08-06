import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrcode_scanner/main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:qrcode_scanner/screens/gallery.dart';
import 'package:qrcode_scanner/screens/generator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:scan/scan.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  XFile? picture;
  late CameraController controller;
  late String url;

  open(pic) async {
    if (pic != null) {
      String? url = await Scan.parse(pic!.path);
      if (url != null) {
        launch(url.toString());
      }
      pic = null;
    }
  }

  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.max);
    controller.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const SizedBox(
          child: Center(
        child: CircularProgressIndicator(),
      ));
    }

    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.centerStart,
        children: [
          SizedBox(
            child: CameraPreview(controller),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Container(
            alignment: const Alignment(0, 0.7),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(15),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                onPressed: () async {
                  try {
                    picture = await controller.takePicture();
                  } on Exception catch (e) {}
                  setState(() {});
                  open(picture);
                },
                child: Icon(Icons.camera_alt)),
          ),
          Container(
            alignment: const Alignment(0.6, 0.7),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(5),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => generator(context),
                  );
                },
                child: Icon(Icons.qr_code_2)),
          ),
          Container(
            alignment: const Alignment(-0.6, 0.7),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(5),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                onPressed: (() async {
                  await gallery(context);
                }),
                child: Icon(Icons.photo_album_rounded)),
          )
        ],
      ),
    );
  }
}
