import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

LocalObjectDetectorOptions getDetectionOptions(String modelPath) {
  return LocalObjectDetectorOptions(
    mode: DetectionMode.stream,
    modelPath: modelPath,
    classifyObjects: true,
    multipleObjects: true,
  );
}
