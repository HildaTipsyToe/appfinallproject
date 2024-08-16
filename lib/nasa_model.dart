import 'package:flutter/material.dart';

  double sol = 0;
  int cameraCounter = 0;
  String camera = "fhaz";
  String rover = "curiosity";
  int imagecounter = 0;

  List<String> rovers = ['curiosity', 'opportunity', 'spirit'];
  List<String> spiritCameras = [
    'fhaz',
    'rhaz',
    'navcam',
    'pancam',
    'minites',
  ];
  List<String> opportunityCameras = [
    'fhaz',
    'rhaz',
    'navcam',
    'pancam',
    'minites',
  ];
  List<String> curiosityCameras = [
    'fhaz',
    'rhaz',
    'mast',
    'chemcam',
    'mahli',
    'mardi',
    'navcam',
  ];
  List<String> pickedCameraList = [];