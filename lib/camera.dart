import 'package:firebase_ml/picture.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  List<CameraDescription> cameras = [];
  List<Widget> cameraButtons = [];
  CameraController? cameraController;
  CameraDescription? activeCamera;
  CameraPreview? cameraPreview;

  @override
  void initState() {
    super.initState();
    listCameras().then((buttons) {
      setState(() {
        cameraButtons = buttons;
        setCameraController();
      });
    });
  }

  @override
  void dispose() {
    if (cameraController != null) {
      cameraController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Camera View'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: cameraButtons.isEmpty
                    ? [const Text("No cameras found")]
                    : cameraButtons,
              ),
              SizedBox(
                height: size.height / 2,
                child: cameraPreview,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (cameraController != null) {
                        takePicture().then((picture) {
                          if (picture != null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PictureScreen(picture)));
                          }
                        });
                      }
                    },
                    child: const Text('Take Picture'),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Future<List<Widget>> listCameras() async {
    List<Widget> buttons = [];

    cameras = await availableCameras();

    if (cameras.isEmpty) {
      return buttons;
    }

    activeCamera ??= cameras.first;

    cameraButtons = cameras.map((camera) {
      return ElevatedButton(
        onPressed: () {
          setState(() {
            activeCamera = camera;
            setCameraController();
          });
        },
        child: Row(
          children: [
            const Icon(Icons.camera_alt),
            Text(camera.name),
          ],
        ),
      );
    }).toList();
    return cameraButtons;
  }

  void setCameraController() async {
    if (activeCamera == null) {
      return;
    }
    if (cameraController != null) {
      cameraController!.dispose();
    }

    cameraController = CameraController(
      activeCamera!,
      ResolutionPreset.high,
    );

    try {
      await cameraController!.initialize();
    } catch (e) {
      print('Camera initialization failed: $e');
      return;
    }

    setState(() {
      cameraPreview = CameraPreview(cameraController!);
    });
  }

  Future takePicture() async {
    if (cameraController == null) {
      return;
    }

    if (!cameraController!.value.isInitialized) {
      return;
    }

    if (cameraController!.value.isTakingPicture) {
      return;
    }

    try {
      await cameraController!.setFlashMode(FlashMode.off);
      XFile picture = await cameraController!.takePicture();
      return picture;
    } catch (e) {
      print('Failed to take picture: $e');
    }
  }
}
