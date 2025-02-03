import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../model/gamemodel.dart';
import '../Details Screen/Details.dart';
import 'DataScreenController.dart';

class DataScreen extends StatelessWidget {
  DataScreen({super.key});
  final controller = Get.put(DataScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back(); // GetX back navigation
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        title: Text(
          controller.name,
          style: TextStyle(
            color: Colors.white,
            fontSize: 25.r,
            fontFamily: 'opensans',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Determine whether to use ListView or GridView
              controller.name == 'Tips & Tricks' || controller.name == 'FAQs'
                  ? forListView()
                  : Expanded(
                      child: SizedBox(
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          itemCount: controller.alldata.length,
                          padding: EdgeInsets.symmetric(
                              vertical: 20.r, horizontal: 20.r),
                          itemBuilder: (context, index) {
                            final item = controller.alldata[index];
                            return buildGridTile(item, index);
                          },
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  // ListView for 'Tips & Tricks' or 'FAQs'
  Widget forListView() {
    return Expanded(
      child: SizedBox(
        child: ListView.builder(
          itemCount: controller.alldata.length,
          padding: EdgeInsets.symmetric(vertical: 15.r, horizontal: 15.r),
          itemBuilder: (context, index) {
            final item = controller.alldata[index];
            return buildListTile(item, index);
          },
        ),
      ),
    );
  }

  // Grid tile widget
  Widget buildGridTile(GameItemData item, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(width: 3.r, color: Colors.black),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            offset: Offset(6.r, 6.r),
            blurRadius: 10.r,
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(vertical: 10.r, horizontal: 10.r),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(width: 3.r, color: Colors.black),
        ),
        margin: EdgeInsets.all(4.r),
        padding: EdgeInsets.only(bottom: 5.r),
        child: ListTile(
          onTap: () {
            Get.to(() => Detailscreen(), arguments: {'data': item});
          },
          title: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 7.r),
              child: Image.network(
                item.image.toString(),
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // List tile widget for ListView
  Widget buildListTile(GameItemData item, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(width: 3.r, color: Colors.black),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            offset: Offset(6.r, 6.r),
            blurRadius: 10.r,
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(vertical: 10.r),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(width: 3.r, color: Colors.black),
        ),
        margin: EdgeInsets.all(4.r),
        child: ListTile(
          onTap: () {
            Get.to(() => Detailscreen(), arguments: {'data': item});
          },
          leading: Text(
            '${index + 1}.',
            style: TextStyle(
              fontFamily: 'opensans',
              fontSize: 22.r,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          title: Text(
            item.title.toString(),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'opensans',
              fontSize: 22.r,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios_sharp,
            color: Colors.black,
            size: 18.r,
          ),
        ),
      ),
    );
  }
}
