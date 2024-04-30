import 'package:camera/camera.dart';
import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:recordingcameraa/main.dart';

class CreateVid extends StatefulWidget {
  const CreateVid({super.key});

  @override
  State<CreateVid> createState() => _CreateVidState();
}

class _CreateVidState extends State<CreateVid> {
  late Floating floating;
  late CameraController controller;
  late Future<void> initializeControllerFuture;
  bool isRecording = false;
  String? path;
  bool isFullScreen = false;
  bool isSaving = false; // Flag to indicate if video is being saved

  @override
  void initState() {
    super.initState();
    floating = Floating();
    controller = CameraController(
      cameras[0],
      ResolutionPreset.medium,
    );
    initializeControllerFuture = controller.initialize().then((_) {
      // Start recording when the controller is initialized
      _toggleRecording();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
    floating.dispose();
  }

  Future<void> _saveVideoToGallery(XFile video) async {
    setState(() {
      isSaving = true; // Set saving flag to true
    });

    // Save the video to the device's gallery
    final gallerySaveResult = await GallerySaver.saveVideo(video.path);
    // ignore: avoid_print
    print('Gallery Save Result: $gallerySaveResult'); // For debugging purposes

    setState(() {
      isSaving = false; // Reset saving flag to false
    });
  }

  Future<void> _toggleRecording() async {
    if (isSaving) {
      return; // If saving, don't start new recording
    }

    try {
      await initializeControllerFuture;

      if (!isRecording) {
        // Start recording
        path = join(
          (await getApplicationDocumentsDirectory()).path,
          '${DateTime.now()}.mp4',
        );
        await controller.startVideoRecording();
        setState(() {
          isRecording = true;
        });
      } else {
        // Stop recording
        XFile video = await controller.stopVideoRecording();
        _saveVideoToGallery(video);
        setState(() {
          isRecording = false;
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PiPSwitcher(
        childWhenEnabled: Scaffold(
          body: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 1,
              child: CameraPreview(controller),
            ),
          ),
        ),
        childWhenDisabled: FutureBuilder<void>(
          future: initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                children: [
                  Stack(
                    children: [
                      CameraPreview(controller),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.28,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FloatingActionButton(
                        onPressed: () async {
                          if (!isSaving) {
                            await floating.enable(
                                aspectRatio: const Rational.landscape());
                            setState(() {
                              isFullScreen = true;
                            });
                          }
                        },
                        tooltip: 'Accessibility Options',
                        child: const Icon(Icons.videocam),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                      ),
                      FloatingActionButton(
                        onPressed: () async {
                          if (!isSaving && controller.value.isRecordingVideo) {
                            final XFile video =
                                await controller.stopVideoRecording();
                            _saveVideoToGallery(video);
                          }
                        },
                        tooltip: 'Accessibility Options',
                        child: const Icon(Icons.save),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          _toggleRecording();
                        },
                        tooltip: 'Accessibility Options',
                        child: Icon(isRecording ? Icons.pause : Icons.videocam),
                      ),
                    ],
                  ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
