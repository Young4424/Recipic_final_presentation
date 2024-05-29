import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';

bool isValidFormat(InputImageFormat format) {
  return (Platform.isAndroid && format == InputImageFormat.nv21) || (Platform.isIOS && format == InputImageFormat.bgra8888);
}

InputImageRotation getRotation(DeviceOrientation orientation, int sensorOrientation, CameraLensDirection lensDirection) {
  final orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  var rotationCompensation = orientations[orientation];
  if (rotationCompensation == null) return InputImageRotation.rotation0deg;

  if (lensDirection == CameraLensDirection.front) {
    rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
  } else {
    rotationCompensation = (sensorOrientation - rotationCompensation + 360) % 360;
  }

  return InputImageRotationValue.fromRawValue(rotationCompensation) ?? InputImageRotation.rotation0deg;
}
