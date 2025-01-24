import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'MmrewardController.dart';
import 'RewardDetail.dart';
import 'RewardDetailController.dart';

class MmrewardScreen extends StatelessWidget {
  MmrewardScreen({super.key});

  final controller = Get.put(MmrewardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        title: Text(
          'MM Reward',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25.r,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w600,
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
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: LoadingAnimationWidget.hexagonDots(
                color: Colors.white,
                size: 40.sp,
              ),
            );
          } else {
            final groupedData = <String, List>{};
            for (var item in controller.rewardData.value.data) {
              final date = controller.formatDate(int.parse(item.date));
              if (groupedData.containsKey(date)) {
                groupedData[date]!.add(item);
              } else {
                groupedData[date] = [item];
              }
            }

            return ListView.builder(
              itemCount: groupedData.keys.length,
              itemBuilder: (context, index) {
                final date = groupedData.keys.elementAt(index);
                final data = groupedData.values.elementAt(index);

                return Column(
                  children: [
                    Text(
                      date,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                        fontSize: 25.r,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    8.verticalSpace,
                    SizedBox(
                      height: (data.length / 2).ceil() * 200.r,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.r, horizontal: 10.r),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            final reward = data[index];
                            final RxBool isClaimed =
                                false.obs; // Track claim state
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
                              margin: EdgeInsets.symmetric(
                                  vertical: 5.r, horizontal: 5.r),
                              child: GestureDetector(
                                onTap: isClaimed.value
                                    ? null
                                    : () {
                                        isClaimed.value = true;
                                        Get.to(() => RewardDetailScreen(),
                                            binding: BindingsBuilder(() {
                                          Get.put(RewardDetailController(
                                              reward, date));
                                        }));
                                      },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18.r),
                                    border: Border.all(
                                        width: 3.r, color: Colors.black),
                                  ),
                                  margin: EdgeInsets.all(4.r),
                                  padding: EdgeInsets.only(top: 4.r),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 52.r,
                                        width: 50.r,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey,
                                              blurRadius: 10.r,
                                              offset: Offset(4.r, 4.r),
                                            ),
                                          ],
                                        ),
                                        child: Image.asset(
                                            'assets/images/reward.png'),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 4.r),
                                        child: Text(
                                          reward.title,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'OpenSans',
                                            fontSize: 15.r,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 5.r),
                                        child: Obx(
                                          () => ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25)),
                                              backgroundColor: Colors.blue,
                                              foregroundColor: Colors.white,
                                              textStyle: TextStyle(
                                                fontSize: 18.r,
                                                fontFamily: 'OpenSans',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            onPressed: isClaimed.value
                                                ? null
                                                : () {
                                                    isClaimed.value = true;
                                                    Get.to(
                                                        () =>
                                                            RewardDetailScreen(),
                                                        binding:
                                                            BindingsBuilder(() {
                                                      Get.put(
                                                          RewardDetailController(
                                                              reward, date));
                                                    }));
                                                  },
                                            child: Text(isClaimed.value
                                                ? 'Claimed'
                                                : 'Claim'),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }
        }),
      ),
    );
  }
}
