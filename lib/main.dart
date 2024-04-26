// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'package:camera/camera.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recordingcameraa/create_vid.dart';

// import 'package:lottie/lottie.dart';
// import 'package:video_player/video_player.dart';
// import 'package:flutter_svg/flutter_svg.dart';
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


// class CameraaPreview extends StatefulWidget {
//   final List<CameraDescription> cameras;
//   const CameraaPreview(
//       {super.key, required this.cameras, required this.permissionStatus});
//   final bool permissionStatus;

//   @override
//   State<CameraaPreview> createState() => _CameraaPreviewState();
// }

// class _CameraaPreviewState extends State<CameraaPreview>
//     with SingleTickerProviderStateMixin {
//   late CameraController _cameraController;
//   late AnimationController _lottieController;
//   Future<void>? _intializeFutureController;
//   VideoPlayerController? _controller;
//   XFile? image;
//   XFile? video;
//   bool _havePic = false;
//   bool _haveVide = false;
//   bool _isRecording = false;
//   // ignore: prefer_final_fields
//   bool _flashOpne = false;
//   late Timer _timer;
//   bool isBackCameraOpen = true;
//   int _recordedSeconds = 0;

//   @override
//   void initState() {
//     _initializeCameraController();
//     _lottieController =
//         AnimationController(vsync: this, duration: const Duration(seconds: 1));
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _cameraController.dispose();
//     _controller!.dispose();
//     _lottieController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Size height = MediaQuery.of(context).size;
//     const double navBarHeight = kBottomNavigationBarHeight;
//     final avatarSize = height.width * 0.0999;
//     final avataPostion = (navBarHeight - avatarSize) / 0.35;

//     return _havePic
//         ? _showImage(image!)
//         : _haveVide
//             ? _showVideo(video!)
//             : FutureBuilder(
//                 future: _intializeFutureController,
//                 builder: (context, snapshot) {
//                   if (!snapshot.hasData) {
//                     return const Center(
//                       child: CircularProgressIndicator(
//                         color: Colors.yellow,
//                       ),
//                     );
//                   } else if (snapshot.hasError) {
//                     return Center(
//                       child: Text('Error: ${snapshot.error}'),
//                     );
//                   } else if (snapshot.hasData) {
//                     return Stack(
//                       children: <Widget>[
//                         if (_cameraController.value.isInitialized &&
//                             _cameraController != null)
//                           AspectRatio(
//                             aspectRatio:
//                                 1.09 / _cameraController.value.aspectRatio,
//                             child: CameraPreview(
//                               _cameraController,
//                             ),
//                           ),

//                         //Recording Button on Camera Screen

//                         Positioned(
//                           bottom: avataPostion / 9,
//                           left: height.width / 2.9 - avatarSize / 2,
//                           child: GestureDetector(
//                             onLongPressStart: (_) => {
//                               _lottieController.forward(),
//                               _lottieController.repeat(
//                                   reverse: true,
//                                   period: const Duration(seconds: 1)),
//                               _startRecording(),
//                             },
//                             onLongPressEnd: (_) => {
//                               _stopRecording(),
//                               _lottieController.stop(),
//                               _lottieController.reset()
//                             },
//                             onTap: () => _clickPrecture(),
//                             child: Lottie.asset("assets/recordingButton.json",
//                                 controller: _lottieController,
//                                 height: 155,
//                                 width: 155,
//                                 fit: BoxFit.cover),
//                           ),
//                         ),

//                         //Camera Rotate Icon on camera Page

//                         Positioned(
//                           top: 65,
//                           left: height.width / 1.18,
//                           child: GestureDetector(
//                             onTap: () => isBackCameraOpen
//                                 ? _openFrontCam()
//                                 : _openBackCam(),
//                             child: SvgPicture.asset(
//                               "assets/camerarotate.svg",
//                               // ignore: deprecated_member_use
//                               color: Colors.white,
//                               height: 25,
//                             ),
//                           ),
//                         ),
//                         if (_isRecording)
//                           Positioned(
//                             top: 20,
//                             left: height.width / 2.25,
//                             child: Text(
//                               '$_recordedSeconds s',
//                               style: const TextStyle(
//                                 color: Colors.red,
//                                 fontSize: 24,
//                               ),
//                             ),
//                           ),
//                       ],
//                     );
//                   }
//                   ;
//                 });
//   }

//   void _clickPrecture() async {
//     if (_cameraController.value.isInitialized) {
//       if (_flashOpne) {
//         _cameraController.setFlashMode(FlashMode.always);
//       } else if (!_flashOpne) {
//         _cameraController.setFlashMode(FlashMode.off);
//       }

//       image = await _cameraController.takePicture();
//       setState(() {
//         _havePic = !_havePic;
//       });
//     }
//   }

//   void _startRecording() async {
//     if (_cameraController.value.isInitialized) {
//       if (_flashOpne) {
//         _cameraController.setFlashMode(FlashMode.always);
//       } else if (!_flashOpne) {
//         _cameraController.setFlashMode(FlashMode.off);
//       }

//       _cameraController.startVideoRecording();
//       _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//         setState(() {
//           _recordedSeconds += 1;
//         });
//       });
//       setState(() {
//         _isRecording = true;
//       });
//     }
//   }

//   void _stopRecording() async {
//     if (_cameraController.value.isRecordingVideo) {
//       _timer.cancel();
//       _recordedSeconds = 0;
//       video = await _cameraController.stopVideoRecording();

//       setState(() {
//         _isRecording = false;
//         _haveVide = !_haveVide;
//         _controller = VideoPlayerController.file(File(video!.path))
//           ..initialize()
//           ..setLooping(true).then((_) {
//             _controller!.play();
//           });
//       });
//     }
//   }

//   void _openFrontCam() {
//     _cameraController = CameraController(
//         widget.cameras[1], ResolutionPreset.ultraHigh,
//         imageFormatGroup: ImageFormatGroup.jpeg);

//     setState(() {
//       _intializeFutureController = _cameraController.initialize();
//       isBackCameraOpen = !isBackCameraOpen;
//     });
//   }

//   void _openBackCam() {
//     _cameraController = CameraController(
//         widget.cameras[0], ResolutionPreset.ultraHigh,
//         imageFormatGroup: ImageFormatGroup.jpeg);

//     setState(() {
//       _intializeFutureController = _cameraController.initialize();
//       isBackCameraOpen = !isBackCameraOpen;
//     });
//   }

//   _showImage(XFile? image) {
//     return Stack(
//       children: [
//         SizedBox(
//           height: MediaQuery.of(context).size.height,
//           width: MediaQuery.of(context).size.width,
//           child: Image.file(
//             File(image!.path),
//             fit: BoxFit.cover,
//           ),
//         ),
//         Positioned(
//           top: 55,
//           right: MediaQuery.of(context).size.width / 1.18,
//           child: GestureDetector(
//             onTap: () => setState(
//               () {
//                 _havePic = !_havePic;
//                 _isRecording = false;
//               },
//             ),
//             child: SvgPicture.asset(
//               "assets/cancel.svg",
//               // ignore: deprecated_member_use
//               color: Colors.white,
//               height: 25,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Future<void> _initializeCameraController() async {
//     _cameraController = CameraController(
//       widget.cameras[0],
//       ResolutionPreset.ultraHigh,
//       enableAudio: true,
//       imageFormatGroup: ImageFormatGroup.jpeg,
//     );

//     setState(() {
//       _intializeFutureController = _cameraController.initialize();
//     });
//   }

//   _showVideo(XFile? v) {
//     return Stack(
//       children: [
//         SizedBox(
//           height: MediaQuery.of(context).size.height,
//           width: MediaQuery.of(context).size.width,
//           child: VideoPlayer(_controller!),
//         ),
//         Positioned(
//           top: 55,
//           right: MediaQuery.of(context).size.width / 1.18,
//           child: GestureDetector(
//             onTap: () => setState(
//               () {
//                 _haveVide = !_haveVide;

//                 _controller!.pause();
//               },
//             ),
//             child: SvgPicture.asset(
//               "assets/cancel.svg",
//               // ignore: deprecated_member_use
//               color: Colors.white,
//               height: 25,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
