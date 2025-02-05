import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:matchapp/views/MainMenu%20Screen/MainMenuController.dart';
import '../../api/menuapi.dart';
import '../Data Screen/Data.dart';
import '../Gifs Screen/Gifs.dart';
import '../Gifs Screen/GifsController.dart';
import '../MMReward Screen/Mmreward.dart';
import '../Setting Screen/Setting.dart';
import '../Statistics Screen/Statistics.dart';

class MenuScreen extends StatelessWidget {

  static const String routeName='/MenuScreen';

  MenuScreen({super.key});

  final controller = Get.put(MainMenuController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Text(
                "Main Menu",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'opensans',
                  fontSize: 30.r,
                  fontWeight: FontWeight.bold,
                ),
              ),
              10.verticalSpace,
              FutureBuilder(
                future: ApiCall().fetchData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: MenuList.menuList.length,
                        padding: EdgeInsets.symmetric(
                            vertical: 15.r, horizontal: 15.r),
                        itemBuilder: (context, index) {
                          var alldata = snapshot.data;
                          var menulist = MenuList.menuList[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(22.r),
                              border:
                                  Border.all(width: 3.r, color: Colors.black),
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
                                border:
                                    Border.all(width: 3.r, color: Colors.black),
                              ),
                              margin: EdgeInsets.all(4.r),
                              padding: EdgeInsets.all(8.r),
                              child: ListTile(
                                onTap: () {
                                  if (index == 0) {
                                    Get.to(() => MmrewardScreen());
                                  } else if (index == 1) {
                                    Get.to(() => GifsScreen(),
                                        binding: BindingsBuilder(() {
                                      Get.put(GifsController());
                                    }));
                                  } else if (index == 2 || index == 3) {
                                    Get.to(() => DataScreen(), arguments: {
                                      'data': alldata![index + 1].data,
                                      'name': alldata[index + 1].name
                                    });
                                  } else if (index == 4) {
                                    Get.to(() => const StatisticsScreen());
                                  } else if (index == 5 || index == 6) {
                                    Get.to(() => DataScreen(), arguments: {
                                      'data': alldata![index - 4].data,
                                      'name': alldata[index - 4].name
                                    });
                                  } else if (index == 7) {
                                    Get.to(() => DataScreen(), arguments: {
                                      'data': alldata![index - 7].data,
                                      'name': alldata[index - 7].name
                                    });
                                  } else if (index == 8) {
                                    Get.to(() => const SettingScreen());
                                  }
                                },
                                leading: Image(
                                  image: AssetImage(menulist.images),
                                ),
                                title: Text(
                                  menulist.name.toString(),
                                  style: TextStyle(
                                    fontFamily: 'opensans',
                                    fontSize: 25.r,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddListtile {
  final String images;
  final String name;

  AddListtile({required this.images, required this.name});
}

class MenuList {
  static final menuList = [
    AddListtile(images: 'assets/images/reward.png', name: 'MM Rewards'),
    AddListtile(images: 'assets/images/gif.png', name: 'Top GIFs'),
    AddListtile(images: 'assets/images/book.png', name: 'Tips & Tricks'),
    AddListtile(images: 'assets/images/faq.png', name: 'Latest FAQs'),
    AddListtile(images: 'assets/images/stats.png', name: 'Statistics'),
    AddListtile(images: 'assets/images/modifiers.png', name: 'Modifiers'),
    AddListtile(images: 'assets/images/studios.png', name: 'Studios'),
    AddListtile(images: 'assets/images/modes.png', name: 'Modes'),
    AddListtile(images: 'assets/images/setting.png', name: 'Settings'),
  ];
}
