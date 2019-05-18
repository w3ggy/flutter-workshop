import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_workshop/models/NewPost.dart';
import 'package:flutter_workshop/presentation/main/MainPage.dart';
import 'package:flutter_workshop/presentation/ui_components/Alerts.dart';
import 'package:flutter_workshop/presentation/ui_components/LoadableWidget.dart';
import 'package:flutter_workshop/presentation/ui_components/WorkshopAppBar.dart';
import 'package:flutter_workshop/resources/ColorRes.dart';
import 'package:flutter_workshop/resources/ImageRes.dart';
import 'package:flutter_workshop/services/PhotoService.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_cropper/image_cropper.dart';

class CameraPage extends StatefulWidget {
  final GlobalKey<MainPageState> mainPageKey;

  CameraPage(this.mainPageKey);

  @override
  State<StatefulWidget> createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  CameraController controller;
  bool isPhotoUploading = false;
  UploadPhotoTask currentTask;

  @override
  Widget build(BuildContext context) {
    return LoadableWidget(
      loading: isPhotoUploading,
      child: Scaffold(
        appBar: buildHeader(context),
        body: buildBody(),
        bottomNavigationBar: buildFooter(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    loadCameraDescription();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        controller?.dispose();
        break;

      case AppLifecycleState.resumed:
        if (controller != null) {
          onNewCameraSelected(controller.description);
        }
        break;

      default:
        break;
    }
  }

  Widget buildHeader(BuildContext context) {
    return WorkshopAppBar(
      titleWidget: Image.asset(ImageRes.workshop),
    );
  }

  Widget buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Flexible(
          child: Container(
            color: ColorRes.black,
            child: buildCameraPreviewWidget(),
          ),
        ),
      ],
    );
  }

  Widget buildFooter() {
    return Container(
      alignment: Alignment.center,
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [ColorRes.black, ColorRes.darkIndigo],
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(child: buildGalleryButton()),
          buildShotButton(),
          Expanded(child: Container()),
        ],
      ),
    );
  }

  GestureDetector buildShotButton() {
    return GestureDetector(
      onTap: _onTakePicturePressed,
      child: Image(
        image: AssetImage(ImageRes.icShot),
        width: 80,
        height: 80,
      ),
    );
  }

  GestureDetector buildGalleryButton() {
    return GestureDetector(
      onTap: getImage,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: ColorRes.lightPeriwinkle),
              image: DecorationImage(
                image: AssetImage(ImageRes.icGallery),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return Center(
        child: Text(
          'Camera not available',
          style: TextStyle(
            color: ColorRes.white,
            fontSize: 24.0,
            fontWeight: FontWeight.w900,
          ),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: CameraPreview(controller),
    );
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }

    controller = CameraController(cameraDescription, ResolutionPreset.high);

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (controller.value.hasError) {
        showInSnackBar('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _showCameraException(CameraException e) {
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  void showInSnackBar(String message) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void _onTakePicturePressed() {
    takePicture().then((String filePath) {
      if (mounted && filePath != null) {
        _handleImage(File(filePath));
      }
    });
  }

  Future<String> takePicture() async {
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    final String filePath = '$dirPath/${timestamp()}.jpg';

    await Directory(dirPath).create(recursive: true);

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }

    return filePath;
  }

  Future<void> loadCameraDescription() async {
    try {
      List<CameraDescription> cameras = await availableCameras();

      if (cameras.length == 0) {
        print("[WARNING]: No cameras are available!");
        return;
      }

      final description = cameras.firstWhere(
        (element) => element.lensDirection == CameraLensDirection.back,
      );

      onNewCameraSelected(description);
    } on CameraException catch (e) {
      _showCameraException(e);
    }
  }

  Future getImage() async {
    final image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      _handleImage(image);
    }
  }

  Future<Null> _handleImage(File image) async {
    File croppedFile = await ImageCropper.cropImage(
      statusBarColor: ColorRes.midnight,
      toolbarColor: ColorRes.darkIndigo,
      toolbarWidgetColor: ColorRes.white,
      sourcePath: image.path,
      ratioX: 1.0,
      ratioY: 1.0,
      maxWidth: 512,
      maxHeight: 512,
    );

    if (croppedFile != null) {
      setState(() {
        isPhotoUploading = true;
      });

      currentTask?.task?.cancel();

      currentTask = PhotoService.instanse.uploadPhoto(croppedFile);

      currentTask.task.onComplete.then((result) {
        setState(() {
          isPhotoUploading = false;
        });

        if (result.error != null) {
          showOperationFailedAlert(context, retry: () => _handleImage(image));
        } else {
          result.ref.getDownloadURL().then((url) {
            PhotoService.instanse.createNewPost(NewPost(
              imageUrl: url,
              createdAt: DateTime.now(),
              userId: 'default user',
            ));
          });

          widget.mainPageKey.currentState.openFeedPage();
        }
      });
    }
  }
}
