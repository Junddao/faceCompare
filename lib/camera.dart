import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';

typedef void Callback(List<dynamic> list);

class Camera extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Callback setOutput;
  final String model;

  Camera(this.cameras, this.setOutput, this.model);

  @override
  _CameraState createState() => new _CameraState();
}

class _CameraState extends State<Camera> {
  CameraController controller;
  bool isDetecting = false;

  @override
  void initState() {
    super.initState();

    if (widget.cameras == null || widget.cameras.length < 1) {
      print('No camera is found');
    } else {
      controller = new CameraController(
        widget.cameras[1],
        ResolutionPreset.high,
      );
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});

        controller.startImageStream((CameraImage img) {
          if (!isDetecting) {
            isDetecting = true;

            Tflite.runModelOnFrame(
                    bytesList: img.planes.map((plane) {
                      return plane.bytes;
                    }).toList(),
                    imageHeight: img.height,
                    imageWidth: img.width,
                    imageMean: 117.0, // defaults to 117.0
                    imageStd: 1.0, // defaults to 1.0
                    numResults: 2, // defaults to 5
                    threshold: 0.001, // defaults to 0.1
                    asynch: true // defaults to
                    )
                .then((value) {
              widget.setOutput(value);
              isDetecting = false;
            });
          }
        });
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller.value.isInitialized) {
      return Container();
    }

    return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller));
  }
}
