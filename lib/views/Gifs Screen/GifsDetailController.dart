import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saver_gallery/saver_gallery.dart';

class GifsDetailController extends GetxController {
  final RxString _sticker = ''.obs;
  String opensans = 'OpenSans';

  /// Requests necessary permissions based on the platform.
  Future<bool> checkAndRequestPermissions({required bool skipIfExists}) async {
    if (!Platform.isAndroid && !Platform.isIOS) return false;

    if (Platform.isAndroid) {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = deviceInfo.version.sdkInt;

      if (skipIfExists) {
        return sdkInt >= 33
            ? await Permission.photos.request().isGranted
            : await Permission.storage.request().isGranted;
      } else {
        return sdkInt >= 29
            ? true
            : await Permission.storage.request().isGranted;
      }
    } else if (Platform.isIOS) {
      return skipIfExists
          ? await Permission.photos.request().isGranted
          : await Permission.photosAddOnly.request().isGranted;
    }

    return false;
  }

  /// Downloads a GIF from the network and saves it to the gallery.
  Future<void> saveGif() async {
    try {
      final response = await Dio().get(
        _sticker.value,
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
      Get.snackbar(
        "Sticker Download ",
        "Sticker saved successfully.",
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
        icon: Icon(Icons.done_outline, color: Colors.white),
        padding: EdgeInsets.all(10.r),
        margin: EdgeInsets.all(10.r),
        forwardAnimationCurve: Curves.easeOutBack,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Sticker Download ",
        "Sticker saving cancelled.",
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
        icon: Icon(Icons.cancel_outlined, color: Colors.white),
        padding: EdgeInsets.all(10.r),
        margin: EdgeInsets.all(10.r),
        forwardAnimationCurve: Curves.easeOutBack,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onInit() {
    super.onInit();
    _sticker.value = Get.arguments['Gifs'];
    log(_sticker.value);
    checkAndRequestPermissions(skipIfExists: false);
  }

  String get stricker => _sticker.value;
}
