import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:qrcode_scanner/main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gallery_saver/gallery_saver.dart';
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

  showpic() {
    if (picture != null) {
      GallerySaver.saveImage(picture!.path);

      return SizedBox();
    } else {
      return SizedBox();
    }
  }

  open() async {
    String? url = await Scan.parse(picture!.path);
    launch(url.toString());
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
      body: Column(
        children: [
          SizedBox(height: 200, width: 200, child: CameraPreview(controller)),
          SizedBox(
            height: 80,
          ),
          Row(
            children: [
              SizedBox(
                width: 160,
              ),
              ElevatedButton(
                  onPressed: () async {
                    picture = await controller.takePicture();
                    setState(() {});
                  },
                  child: Icon(Icons.camera))
            ],
          ),
          SizedBox(
            child: showpic(),
          ),
          ElevatedButton(onPressed: (() => open()), child: Text("open url"))
        ],
      ),
    );
  }
}
