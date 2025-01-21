import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';

class GifsDetailScreen extends StatefulWidget {
  final String data;

  const GifsDetailScreen({super.key, required this.data});

  @override
  State<GifsDetailScreen> createState() => _GifsDetailScreenState();
}

class _GifsDetailScreenState extends State<GifsDetailScreen> {
  String opensans = 'OpenSans';
  late String sticker;
  var random = Random();

  Future<void> _saveImage(String stickerGif) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    String message;

    try {
      // Download the image
      final response = await Dio().get(
        stickerGif,
        options: Options(responseType: ResponseType.bytes),
      );

      // Get the temporary directory
      final dir = await getTemporaryDirectory();

      // Create an image file name
      final filename = '${dir.path}/SaveImage${random.nextInt(100)}.gif';

      // Write the image to the file
      final file = File(filename);
      await file.writeAsBytes(response.data);

      // Prompt the user to save the file
      final params = SaveFileDialogParams(sourceFilePath: file.path);
      final finalPath = await FlutterFileDialog.saveFile(params: params);

      if (finalPath != null) {
        message = 'Image saved successfully.';
      } else {
        message = 'Image saving cancelled.';
      }
    } catch (e) {
      message = 'Error saving image: $e';
    }

    // Show a snack bar with the result
    scaffoldMessenger.showSnackBar(SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(Icons.done_outline,size: 25,color: Colors.white,),
          Text(
            message,
            style: TextStyle(
                fontSize: 18.r,
                fontFamily: opensans,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
      backgroundColor: Colors.black38,
    ));
  }

  @override
  void initState() {
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
                        _saveImage(sticker);
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
