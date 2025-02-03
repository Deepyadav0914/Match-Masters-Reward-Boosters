import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../main.dart';
import '../../model/gifmodel.dart';
import 'GifsController.dart';
import 'GifsDetail.dart';

class GifsScreen extends StatefulWidget {
  const GifsScreen({super.key});

  @override
  State<GifsScreen> createState() => _GifsScreenState();
}

class _GifsScreenState extends State<GifsScreen> {
  final controller = Get.put(GifsController());

  @override
  Widget build(BuildContext context) {
    final unlockGifs = box.read<Map<String, dynamic>>('unlockGifs') ?? {};
    print("unlockGifs == ${unlockGifs.length}");

    return GetBuilder<GifsController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(Icons.arrow_back, color: Colors.white),
            ),
            backgroundColor: Colors.blue,
            title: Text(
              'Top GIFs',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25.r,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 10.r),
                child: Container(
                  height: 36.r,
                  width: 100.r,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(width: 3, color: Colors.white),
                    color: Colors.blue,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/reward.png',
                        height: 22.r,
                      ),
                      10.horizontalSpace,
                      Obx(() => Text(
                            '${controller.totalCoins.value}',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'OpenSans',
                              fontSize: 18.r,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ],
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
            child: Obx(() {
              return FutureBuilder<GifsModel>(
                future: controller.gifsData.value,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
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
                            onPressed: () => controller.retry(),
                            child: const Text("Retry"),
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasData) {
                    final allgifs = snapshot.data!.data;
                    print(allgifs.length);
                    box.write('totalgif', allgifs.length);


                    return SafeArea(
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            SizedBox(
                              height: (allgifs.length / 2).ceil() * 200.r,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 14.r, horizontal: 10.r),
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                  ),
                                  itemCount: allgifs.length,
                                  itemBuilder: (context, index) {
                                    String uniqueKey = "$index";
                                    print("uniqueKey == $uniqueKey");

                                    bool isLocked =
                                        unlockGifs[uniqueKey] ?? false;

                                    return Padding(
                                      padding: EdgeInsets.only(
                                          left: 6.r, right: 6.r, top: 7.r),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(22.r),
                                          border: Border.all(
                                              width: 3.r, color: Colors.black),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black,
                                              offset: Offset(6.r, 6.r),
                                              blurRadius: 10.r,
                                            ),
                                          ],
                                        ),
                                        margin: EdgeInsets.symmetric(
                                            vertical: 3.r, horizontal: 5.r),
                                        child: GestureDetector(
                                          onTap: () {
                                            Get.to(() => GifsDetailScreen(),
                                                arguments: {
                                                  'Gifs': allgifs[index]
                                                });
                                          },
                                          child: Stack(children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(18.r),
                                                border: Border.all(
                                                    width: 3.r,
                                                    color: Colors.black),
                                              ),
                                              margin: EdgeInsets.all(4.r),
                                              child: Center(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 12.r),
                                                  child: CachedNetworkImage(
                                                    placeholder: (context,
                                                            url) =>
                                                        LoadingAnimationWidget
                                                            .threeArchedCircle(
                                                      color: Colors.black45,
                                                      size: 20.sp,
                                                    ),
                                                    imageUrl: allgifs[index]
                                                        .toString(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            isLocked
                                                ? SizedBox()
                                                : Positioned(
                                                    top: 5.r,
                                                    right: 5.r,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        if (controller
                                                                .totalCoins
                                                                .value <
                                                            150) {
                                                          Get.snackbar(
                                                            "Not Enough Tokens",
                                                            "You need at least 150 tokens to unlock this GIF.",
                                                            snackPosition:
                                                                SnackPosition
                                                                    .TOP,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10.r),
                                                            backgroundColor:
                                                                Colors.red,
                                                            colorText:
                                                                Colors.white,
                                                          );

                                                          return;
                                                        }

                                                        setState(() {
                                                          unlockGifs[
                                                              uniqueKey] = true;
                                                          box.write(
                                                              "unlockGifs",
                                                              unlockGifs);
                                                        });

                                                        final gifsController =
                                                            Get.put(
                                                                GifsController());
                                                        gifsController
                                                            .unlockedGifs(
                                                                controller
                                                                    .rewardCoins);
                                                      },
                                                      child: Container(
                                                        height: 140.r,
                                                        width: 130.r,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.black
                                                              .withOpacity(0.9),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.r),
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Image.asset(
                                                              'assets/images/lock.png',
                                                              height: 60.r,
                                                            ),
                                                            8.verticalSpace,
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Image.asset(
                                                                  'assets/images/reward.png',
                                                                  height: 25.r,
                                                                ),
                                                                5.horizontalSpace,
                                                                Text(
                                                                    '150 Token',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontFamily:
                                                                            'OpenSans',
                                                                        fontSize: 20
                                                                            .r,
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                          ]),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Container();
                },
              );
            }),
          ),
        );
      },
    );
  }
}
