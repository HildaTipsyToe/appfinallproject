import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Nasa {
  final List<MarsPhoto> list;

  Nasa({
    required this.list,
  });

  factory Nasa.fromJson(Map<String, dynamic> json) {
    return Nasa(
      list: (json['photos'] as List).map((photoJson) => MarsPhoto.fromJson(photoJson)).toList(),
    );
  }
  String tt(){
    return 'Nasa(\n  list: ${list.map((photo) => photo.toString()).join(',\n')}\n)';
  }

  @override
  String toString() {
    return 'Nasa(\n  list: ${list.map((photo) => photo.toString()).join(',\n')}\n)';
  }
}

class MarsPhoto {
  final int id;
  final int sol;
  final Camera camera;
  final String imgSrc;
  final DateTime earthDate;
  final Rover rover;

  MarsPhoto({
    required this.id,
    required this.sol,
    required this.camera,
    required this.imgSrc,
    required this.earthDate,
    required this.rover,
  });

  factory MarsPhoto.fromJson(Map<String, dynamic> json) {
    return MarsPhoto(
      id: json['id'],
      sol: json['sol'],
      camera: Camera.fromJson(json['camera']),
      imgSrc: json['img_src'],
      earthDate: DateTime.parse(json['earth_date']),
      rover: Rover.fromJson(json['rover']),
    );
  }

  @override
  String toString() {
    return 'MarsPhoto(\n  id: $id,\n  sol: $sol,\n  camera: $camera,\n  imgSrc: $imgSrc,\n  earthDate: $earthDate,\n  rover: $rover\n)';
  }
}

class Camera {
  final int id;
  final String name;
  final int roverId;
  final String fullName;

  Camera({
    required this.id,
    required this.name,
    required this.roverId,
    required this.fullName,
  });

  factory Camera.fromJson(Map<String, dynamic> json) {
    return Camera(
      id: json['id'],
      name: json['name'],
      roverId: json['rover_id'],
      fullName: json['full_name'],
    );
  }

  @override
  String toString() {
    return 'Camera(\n    id: $id,\n    name: $name,\n    roverId: $roverId,\n    fullName: $fullName\n  )';
  }
}

class Rover {
  final int id;
  final String name;
  final DateTime landingDate;
  final DateTime launchDate;
  final String status;
  final int maxSol;
  final DateTime maxDate;
  final int totalPhotos;
  final List<RoverCamera> cameras;

  Rover({
    required this.id,
    required this.name,
    required this.landingDate,
    required this.launchDate,
    required this.status,
    required this.maxSol,
    required this.maxDate,
    required this.totalPhotos,
    required this.cameras,
  });

  factory Rover.fromJson(Map<String, dynamic> json) {
    return Rover(
      id: json['id'],
      name: json['name'],
      landingDate: DateTime.parse(json['landing_date']),
      launchDate: DateTime.parse(json['launch_date']),
      status: json['status'],
      maxSol: json['max_sol'],
      maxDate: DateTime.parse(json['max_date']),
      totalPhotos: json['total_photos'],
      cameras: (json['cameras'] as List)
          .map((cameraJson) => RoverCamera.fromJson(cameraJson))
          .toList(),
    );
  }

  @override
  String toString() {
    return 'Rover(\n    id: $id,\n    name: $name,\n    landingDate: $landingDate,\n    launchDate: $launchDate,\n    status: $status,\n    maxSol: $maxSol,\n    maxDate: $maxDate,\n    totalPhotos: $totalPhotos,\n    cameras: ${cameras.map((camera) => camera.toString()).join(',\n')}\n  )';
  }
}

class RoverCamera {
  final String name;
  final String fullName;

  RoverCamera({
    required this.name,
    required this.fullName,
  });

  factory RoverCamera.fromJson(Map<String, dynamic> json) {
    return RoverCamera(
      name: json['name'],
      fullName: json['full_name'],
    );
  }

  @override
  String toString() {
    return 'RoverCamera(\n      name: $name,\n      fullName: $fullName\n    )';
  }
}
