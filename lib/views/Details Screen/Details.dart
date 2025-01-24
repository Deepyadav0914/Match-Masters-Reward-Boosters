import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../model/gamemodel.dart';

class DetailscreenController extends GetxController {
  // You can manage any state or logic related to the screen here if needed
  RxString title = ''.obs;

}

class Detailscreen extends StatelessWidget {
  final String name;
  final GameItemData item;
  final String opensans = 'OpenSans';

  // Injecting the GetX controller
  final DetailscreenController controller = Get.put(DetailscreenController());

  Detailscreen({super.key, required this.name, required this.item});

  @override
  Widget build(BuildContext context) {
    // Set the title based on the item data
    if (item.title != null) {
      controller.title.value = item.title.toString();
    } else if (item.name != null) {
      controller.title.value = '';
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
        title:  Text(
              item.name == null ? "Details" : item.name.toString(),
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
              children: [
                10.verticalSpace,
                item.image == ""
                    ? SizedBox()
                    : Padding(
                        padding: EdgeInsets.all(10.r),
                        child: Center(
                          child: Image.network(
                            item.image,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                name == "" && item.name == "" && item.title == ""
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
                                child: Obx(() => Text(
                                      controller.title.value,
                                      style: TextStyle(
                                          fontSize: 25.r,
                                          fontFamily: opensans,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w700),
                                    )),
                              ),
                            ),
                            item.title != null
                                ? Padding(
                                    padding: EdgeInsets.only(
                                        left: 18.r, right: 18.r),
                                    child: Divider(
                                      color: Colors.black,
                                      thickness: 3,
                                    ),
                                  )
                                : SizedBox(),
                            10.verticalSpace,
                            Center(
                              child: Text(
                                item.description.toString(),
                                style: TextStyle(
                                    fontSize: 22.r,
                                    fontFamily: opensans,
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
