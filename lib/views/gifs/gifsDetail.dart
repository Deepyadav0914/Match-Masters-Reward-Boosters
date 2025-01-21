import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saver_gallery/saver_gallery.dart';

class GifsDetailScreen extends StatefulWidget {
  final String data;

  const GifsDetailScreen({super.key, required this.data});

  @override
  State<GifsDetailScreen> createState() => _GifsDetailScreenState();
}

class _GifsDetailScreenState extends State<GifsDetailScreen> {
  String opensans = 'OpenSans';
  late String sticker;
  late bool statuses;



  /// Requests necessary permissions based on the platform.
  Future<bool> checkAndRequestPermissions({required bool skipIfExists}) async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return false; // Only Android and iOS platforms are supported
    }

    if (Platform.isAndroid) {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = deviceInfo.version.sdkInt;

      if (skipIfExists) {
        // Read permission is required to check if the file already exists
        return sdkInt >= 33
            ? await Permission.photos.request().isGranted
            : await Permission.storage.request().isGranted;
      } else {
        // No read permission required for Android SDK 29 and above
        return sdkInt >= 29
            ? true
            : await Permission.storage.request().isGranted;
      }
    } else if (Platform.isIOS) {
      // iOS permission for saving images to the gallery
      return skipIfExists
          ? await Permission.photos.request().isGranted
          : await Permission.photosAddOnly.request().isGranted;
    }

    return false; // Unsupported platforms
  }



  /// Downloads a GIF from the network and saves it to the gallery.
  Future<void> _saveGif() async {
    try {
      final response = await Dio().get(
        sticker,
        options: Options(responseType: ResponseType.bytes),
      );
      String gifPath = "network_gif.gif";
      final result = await SaverGallery.saveImage(
        Uint8List.fromList(response.data),
        quality: 100,
        fileName: gifPath,
        androidRelativePath: "Pictures/appName/Match Master",
        skipIfExists: false,
      );
      _toastInfo('Sticker saved successfully.');
    } catch (e) {
      _toastInfo('Sticker saving cancelled.');
    }
  }

  /// Displays a toast message with the given information.
   _toastInfo(String info) async {
    print(info);
    Fluttertoast.showToast(msg: info, toastLength: Toast.LENGTH_LONG);
  }

  @override
  void initState() {
    checkAndRequestPermissions(skipIfExists:false);
    sticker = widget.data;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        title: Text(
          'Sticker Download',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25.r,
            fontFamily: opensans,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                90.verticalSpace,
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 60.r),
                    child: CachedNetworkImage(
                      placeholder: (context, url) {
                        return LoadingAnimationWidget.threeArchedCircle(
                          color: Colors.black45,
                          size: 40.sp,
                        );
                      },
                      imageUrl: sticker,
                    ),
                  ),
                ),
                150.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50.r),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28.r),
                      border: Border.all(width: 3.r, color: Colors.black),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(6.r, 6.r),
                          blurRadius: 15.r,
                        ),
                      ],
                    ),
                    margin:
                        EdgeInsets.symmetric(vertical: 5.r, horizontal: 5.r),
                    child: GestureDetector(
                      onTap: () {
                        _saveGif();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.r),
                          border: Border.all(width: 3.r, color: Colors.black),
                        ),
                        margin: EdgeInsets.all(4.r),
                        padding: EdgeInsets.only(bottom: 5.r),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 5.r),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.download,
                                  size: 30.r,
                                  color: Colors.blue,
                                ),
                                Text(
                                  'Download',
                                  style: TextStyle(
                                      fontSize: 25.r,
                                      fontFamily: opensans,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// Future<void> _requestPermission() async {
//   bool statuses;
//   if (Platform.isAndroid) {
//     final deviceInfoPlugin = DeviceInfoPlugin();
//     final deviceInfo = await deviceInfoPlugin.androidInfo;
//     final sdkInt = deviceInfo.version.sdkInt;
//     statuses = sdkInt < 29 ? await Permission.storage.request().isGranted : true;
//   } else {
//     statuses = await Permission.photosAddOnly.request().isGranted;
//   }
//   _toastInfo('Permission Request Result: $statuses');
// }
//  -----------------------------------
//var random = Random();
// Future<void> _saveImage(String sticker) async {
//   final scaffoldMessenger = ScaffoldMessenger.of(context);
//   String message;
//
//   try {
//     // Download the image
//     final response = await Dio().get(
//       sticker,
//       options: Options(responseType: ResponseType.bytes),
//     );
//
//     // Get the temporary directory
//     final dir = await getTemporaryDirectory();
//
//     // Create an Gifs file name
//     final filename = '${dir.path}/GIf_${random.nextInt(1000)}.gif';
//
//     // Write the Gifs to the file
//     final file = File(filename);
//     await file.writeAsBytes(response.data);
//
//     // Prompt the user to save the file
//     final params = SaveFileDialogParams(sourceFilePath: file.path);
//     final finalPath = await FlutterFileDialog.saveFile(params: params);
//
//     if (finalPath != null) {
//       message = 'Image saved successfully.';
//     } else {
//       message = 'Image saving cancelled.';
//     }
//   } catch (e) {
//     message = 'Error saving image: $e';
//   }
//
//   // Show a snack bar with the result
//   scaffoldMessenger.showSnackBar(SnackBar(
//     content: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//
//         Text(
//           message,
//           style: TextStyle(
//               fontSize: 18.r,
//               fontFamily: opensans,
//               color: Colors.white,
//               fontWeight: FontWeight.bold),
//         ),
//       ],
//     ),
//     backgroundColor: Colors.black38,
//   ));
// }