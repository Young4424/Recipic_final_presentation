import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'object_detection.dart';
import 'object_painter.dart';
import 'utils.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:get/get.dart';
import 'package:realtime_object_detection/screen/recognized_ingredient_screen.dart';
import 'package:getwidget/getwidget.dart';




late List<CameraDescription> cameras;

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  dynamic controller;
  bool isBusy = false;
  dynamic objectDetector;
  late Size size;
  dynamic _scanResults;
  CameraImage? img;
  Set<String> detectedObjects = {};

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    loadModel();

    controller = CameraController(
      cameras[0],
      ResolutionPreset.high,
      imageFormatGroup: Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
    );
    await controller.initialize().then((_) {
      if (!mounted) return;
      controller.startImageStream((image) {
        if (!isBusy) {
          isBusy = true;
          img = image;
          doObjectDetectionOnFrame();
        }
      });
    });
  }

  void loadModel() async {
    final modelPath = await getModelPath('assets/ml/model_test.tflite');
    final options = getDetectionOptions(modelPath);
    objectDetector = ObjectDetector(options: options);
  }

  Future<String> getModelPath(String asset) async {
    final path = '${(await getApplicationSupportDirectory()).path}/$asset';
    await Directory(dirname(path)).create(recursive: true);
    final file = File(path);
    if (!await file.exists()) {
      final byteData = await rootBundle.load(asset);
      await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    }
    return file.path;
  }

  Future<void> doObjectDetectionOnFrame() async {
    if (img == null) return;

    final frameImg = getInputImage();
    if (frameImg == null) return;

    try {
      List<DetectedObject> objects = await objectDetector.processImage(frameImg);
      print("len= ${objects.length}");
      Set<String> newDetectedObjects = objects.map((e) => e.labels.first.text).toSet();
      setState(() {
        _scanResults = objects;
        detectedObjects = newDetectedObjects;
      });
    } catch (e) {
      print('Error during object detection: $e');
    }

    isBusy = false;
  }

  InputImage? getInputImage() {
    if (img == null) return null;

    final camera = cameras[0];
    final sensorOrientation = camera.sensorOrientation;
    final rotation = getRotation(controller!.value.deviceOrientation, sensorOrientation, camera.lensDirection);
    final format = InputImageFormatValue.fromRawValue(img!.format.raw);

    if (format == null || !isValidFormat(format)) return null;

    final plane = img!.planes.first;

    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(img!.width.toDouble(), img!.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    objectDetector.close();
    super.dispose();
  }

  Widget buildResult() {
    if (_scanResults == null || controller == null || !controller!.value.isInitialized) {
      return Text('');
    }

    final Size imageSize = Size(
      controller!.value.previewSize!.height,
      controller!.value.previewSize!.width,
    );
    CustomPainter painter = ObjectDetectorPainter(imageSize, _scanResults);
    return CustomPaint(
      painter: painter,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Object detector"),
        backgroundColor: Colors.pinkAccent,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Stack(
              fit: StackFit.expand,
              children: [
                (controller != null && controller!.value.isInitialized)
                    ? AspectRatio(
                  aspectRatio: controller!.value.aspectRatio,
                  child: CameraPreview(controller!),
                )
                    : Container(),
                buildResult(),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(16.0),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "인식된 식재료",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: detectedObjects.length,
                      itemBuilder: (context, index) {
                        String item = detectedObjects.elementAt(index);
                        return ListTile(
                          title: Text(item),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 200,
                        height: 50,
                        child: GFButton(
                          onPressed: () {
                            Get.to(() => RecognizedIngredientsScreen(recogIngr: detectedObjects));
                          },
                          text: "재료 추가하기",
                          color: GFColors.SUCCESS,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
