import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:matchapp/api/menuapi.dart';
import 'package:matchapp/model/gamemodel.dart';
import 'package:matchapp/views/gifs/gifs.dart';
import 'package:matchapp/views/mmreward/mmreward.dart';
import 'package:matchapp/views/setting/setting.dart';
import 'package:matchapp/views/statistics/statistics.dart';
import '../datascreen/data.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late Future<List<GameModel>> _gameData;
  String opensans = 'OpenSans';

  @override
  void initState() {
    super.initState();
    _gameData = ApiCall().fetchData();
  }

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
                  fontFamily: opensans,
                  fontSize: 30.r,
                  fontWeight: FontWeight.w600,
                ),
              ),
              10.verticalSpace,
              Expanded(
                child: SizedBox(
                  child: FutureBuilder<List<GameModel>>(
                    future: _gameData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return  Center(
                          child: LoadingAnimationWidget.hexagonDots(
                            color: Colors.white,
                            size: 40.sp,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Failed to load data. Please try again.',
                                style: TextStyle(
                                  fontSize: 16.r,
                                  color: Colors.red.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              10.verticalSpace,
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _gameData = ApiCall().fetchData();
                                  });
                                },
                                child: const Text("Retry"),
                              ),
                            ],
                          ),
                        );
                      } else if (snapshot.hasData) {
                        var alldata = snapshot.data;

                        return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: MenuList.menuList.length,
                          padding: EdgeInsets.symmetric(
                              vertical: 15.r, horizontal: 15.r),
                          itemBuilder: (context, index) {
                            var menulist = MenuList.menuList[index];
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14.r),
                                border:
                                    Border.all(width: 3.r, color: Colors.black),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black,
                                    offset: Offset(5.r, 6.r),
                                    blurRadius: 15.r,
                                  ),
                                ],
                              ),
                              margin: EdgeInsets.symmetric(vertical: 10.r),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(11.r),
                                  border: Border.all(
                                      width: 3.r, color: Colors.black),
                                ),
                                margin: EdgeInsets.all(6.r),
                                padding: EdgeInsets.all(10.r),
                                child: ListTile(
                                  onTap: () {
                                    if (index == 0) {
                                      Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => MmrewardScreen(data: [],),
                                            ));

                                    } else if (index == 1) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => GifsScreen(data: [],),
                                          ));

                                    } else if (index == 2) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DataScreen(
                                              data: alldata![index+1].data,
                                              name: alldata[index+1].name,
                                            ),
                                          ));
                                    } else if (index == 3) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DataScreen(
                                              data: alldata![index+1].data,
                                              name: alldata[index+1].name,
                                            ),
                                          ));
                                    } else if (index == 4) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => StatisticsScreen(),
                                          ));
                                    } else if (index == 5) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DataScreen(
                                              data: alldata![index-4].data,
                                              name: alldata[index-4].name,
                                            ),
                                          ));

                                    } else if (index == 6) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DataScreen(
                                              data: alldata![index-4].data,
                                              name: alldata[index-4].name,
                                            ),
                                          ));
                                    } else if (index == 7) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DataScreen(
                                              data: alldata![index-7].data,
                                              name: alldata[index-7].name,
                                            ),
                                          ));

                                    } else if (index == 8) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SettingScreen(),
                                          ));
                                    }

                                  },
                                  leading: Image(
                                    image: AssetImage(menulist.images),
                                  ),
                                  title: Text(
                                    menulist.name.toString(),
                                    style: TextStyle(
                                      fontFamily: opensans,
                                      fontSize: 25.r,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                      return 0.verticalSpace;
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
