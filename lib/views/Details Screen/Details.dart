import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'DetailscreenController.dart';

class Detailscreen extends StatelessWidget {
  Detailscreen({super.key});

  final controller = Get.put(DetailscreenController());

  @override
  Widget build(BuildContext context) {
    // Set the title based on the item data
    if (controller.item!.title != null) {
      controller.item!.title = controller.item!.title;
    } else if (controller.item!.name != null) {
      controller.item!.title = '';
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back(); // Use GetX to go back
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        title: Text(
          controller.item!.name == null
              ? "Details"
              : controller.item!.name.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 25.r,
            fontFamily: 'opensans',
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
              children: [
                10.verticalSpace,
                controller.item!.image == ""
                    ? SizedBox()
                    : Padding(
                        padding: EdgeInsets.all(10.r),
                        child: Center(
                          child: Image.network(
                            controller.item!.image,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                controller.item!.name == "" &&
                        controller.item!.name == "" &&
                        controller.item!.title == ""
                    ? SizedBox()
                    : Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 15.r, horizontal: 20.r),
                        child: Column(
                          children: [
                            Center(
                              child: Padding(
                                padding:
                                    EdgeInsets.only(left: 20.r, right: 20.r),
                                child: Text(
                                  controller.item!.title.toString(),
                                  style: TextStyle(
                                      fontSize: 25.r,
                                      fontFamily: 'opensans',
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                            controller.item!.title != ''
                                ? Padding(
                                    padding: EdgeInsets.only(
                                        left: 15.r, right: 15.r),
                                    child: Divider(
                                      color: Colors.black,
                                      thickness: 3,
                                    ),
                                  )
                                : SizedBox(),
                            Center(
                              child: Text(
                                controller.item!.description,
                                style: TextStyle(
                                    fontSize: 22.r,
                                    fontFamily: 'opensans',
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
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
