// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'package:camera/camera.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recordingcameraa/create_vid.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CreateVid(),
    );
  }
}
