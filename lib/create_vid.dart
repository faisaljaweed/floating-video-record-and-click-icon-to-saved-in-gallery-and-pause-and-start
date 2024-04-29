import 'package:camera/camera.dart';
import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recordingcameraa/main.dart';

final aspectRatios = [
  [1, 1],
  [2, 3],
  [3, 2],
  [16, 9],
  [9, 16]
];

class CreateVid extends StatefulWidget {
  const CreateVid({super.key});

  @override
  State<CreateVid> createState() => _CreateVidState();
}

class _CreateVidState extends State<CreateVid> {
  late Floating floating;
  List<int> aspectRation = aspectRatios.first;
  bool isPipAvailable = false;

  late CameraController controller;
  late Future<void> initializeControllerFuture;
  bool isDisable = false;
  String? path;
  @override
  void initState() {
    super.initState();
    floating = Floating();
    requestPipAvailabel();
    controller = CameraController(
      cameras[0],
      ResolutionPreset.medium,
    );
    initializeControllerFuture = controller.initialize();
  }

  void requestPipAvailabel() async {
    isPipAvailable = await floating.isPipAvailable;
    setState(() {});
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
    floating.dispose();
  }

  Future<void> _saveVideoToGallery(XFile video) async {
    // Save the video to the device's gallery
    final gallerySaveResult = await GallerySaver.saveVideo(video.path);
    // ignore: avoid_print
    print('Gallery Save Result: $gallerySaveResult'); // For debugging purposes
  }

  // ignore: annotate_overrides
  Widget build(BuildContext context) {
    return PiPSwitcher(
      childWhenEnabled: FutureBuilder<void>(
          future: initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width *
                        1, // Set width to screen width
                    height: MediaQuery.of(context).size.height * 1,
                    child: CameraPreview(controller),
                  ),
                  // Align(
                  //   alignment: Alignment.bottomCenter,
                  //   child: !controller.value.isRecordingVideo
                  //       ? RawMaterialButton(
                  //           onPressed: () async {
                  //             try {
                  //               await initializeControllerFuture;

                  //               path = join(
                  //                   (await getApplicationDocumentsDirectory())
                  //                       .path,
                  //                   '${DateTime.now()}.mp4');

                  //               setState(() {
                  //                 controller.startVideoRecording();
                  //                 isDisable = true;
                  //                 isDisable = !isDisable;
                  //               });
                  //             } catch (e) {
                  //               // ignore: avoid_print
                  //               print(e);
                  //             }
                  //           },
                  //           // ignore: sort_child_properties_last
                  //           child: const Icon(
                  //             Icons.camera,
                  //             size: 50.0,
                  //             color: Colors.yellow,
                  //           ),
                  //           padding: const EdgeInsets.all(10.0),
                  //           shape: const CircleBorder(),
                  //         )
                  //       : null,
                  // ),
                  // Align(
                  //     alignment: Alignment.bottomCenter,
                  //     child: isDisable == !controller.value.isRecordingVideo
                  //         ? RawMaterialButton(
                  //             onPressed: () async {
                  //               setState(() async {
                  //                 if (controller.value.isRecordingVideo) {
                  //                   final XFile video =
                  //                       await controller.stopVideoRecording();
                  //                   _saveVideoToGallery(video);
                  //                   // controller.stopVideoRecording();
                  //                   isDisable = false;
                  //                   isDisable = !isDisable;
                  //                 }
                  //               });
                  //             },
                  //             // ignore: sort_child_properties_last
                  //             child: const Icon(
                  //               Icons.stop,
                  //               size: 50.0,
                  //               color: Colors.red,
                  //             ),
                  //             padding: const EdgeInsets.all(10.0),
                  //             shape: const CircleBorder(),
                  //           )
                  //         : null)
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      childWhenDisabled: Scaffold(
        appBar: AppBar(
          title: const Text("FLoating example app"),
        ),
        body: const Center(
          child: Text("World"),
        ),
        floatingActionButton: PiPSwitcher(
            childWhenEnabled: const Text("Faisal"),
            childWhenDisabled: FloatingActionButton(
              onPressed: () async {
                try {
                  await initializeControllerFuture;

                  path = join((await getApplicationDocumentsDirectory()).path,
                      '${DateTime.now()}.mp4');

                  setState(() {
                    controller.startVideoRecording();
                    isDisable = true;
                    isDisable = !isDisable;
                  });
                } catch (e) {
                  // ignore: avoid_print
                  print(e);
                }
                final XFile video = await controller.stopVideoRecording();
                _saveVideoToGallery(video);
                // controller.stopVideoRecording();
                isDisable = false;
                isDisable = !isDisable;
                await floating.enable(aspectRatio: const Rational.landscape());
              },
              //   onPressed: () async {
              // await floating.enable(aspectRatio: Rational.landscape());
              // }
            )),
      ),
    );
  }
}
