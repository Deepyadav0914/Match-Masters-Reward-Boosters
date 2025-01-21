import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:matchapp/api/menuapi.dart';
import 'package:matchapp/views/mmreward/rewardDetail.dart';
import '../../model/rewardmodel.dart';

class MmrewardScreen extends StatefulWidget {
  final List<Datum> data;

  const MmrewardScreen({super.key, required this.data});

  @override
  State<MmrewardScreen> createState() => _MmrewardScreenState();
}

class _MmrewardScreenState extends State<MmrewardScreen> {
  late Future<RewardModel> _rewardData;
  String opensans = 'OpenSans';

  @override
  void initState() {
    _rewardData = ApiCall().rewardData();
    super.initState();
  }

  String readTimestamp(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

    final format = DateFormat('dd-MM-yyyy').format(date).toLowerCase();
    return format;
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
          'MM Reward',
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
        child: FutureBuilder<RewardModel>(
            future: _rewardData,
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
                        onPressed: () {
                          setState(() {
                            _rewardData = ApiCall().rewardData();
                          });
                        },
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasData) {
                final allreward = snapshot.data!.data;

                final Map<String, List> groupedData = {};
                for (var item in allreward) {
                  final alldate = readTimestamp(int.parse(item.date));
                  if (groupedData.containsKey(alldate)) {
                    groupedData[alldate]!.add(item);
                  } else {
                    groupedData[alldate] = [item];
                  }
                }

                return ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: groupedData.keys.length,
                  itemBuilder: (context, index) {
                    final date = groupedData.keys.elementAt(index);
                    final data = groupedData.values.elementAt(index);

                    return Column(
                      children: [
                        Text(
                          date.toString(),
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: opensans,
                            fontSize: 25.r,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        10.verticalSpace,
                        SizedBox(
                          height: (data.length / 2).ceil() * 190.r,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 8.r, horizontal: 10.r),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.r,
                                mainAxisSpacing: 15.r,
                                childAspectRatio: 1.0, // Square grid items
                              ),
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.r),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(14.r),
                                      border: Border.all(
                                          width: 3.r, color: Colors.black),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black,
                                          offset: Offset(6.r, 6.r),
                                          blurRadius: 15.r,
                                        ),
                                      ],
                                    ),
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5.r, horizontal: 5.r),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  RewardDetailScreen(
                                                date: date,
                                                data: allreward[index],
                                              ),
                                            ));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(11.r),
                                          border: Border.all(
                                              width: 3.r, color: Colors.black),
                                        ),
                                        margin: EdgeInsets.all(4.r),
                                        padding: EdgeInsets.only(bottom: 0.r),
                                        child: Column(children: [
                                          Center(
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(top: 7.r),
                                              child: Container(
                                                height: 50.r,
                                                width: 50
                                                    .r, // Ensure the container has dimensions matching the image
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors
                                                          .black45, // Shadow color
                                                      blurRadius:
                                                          8.r, // Blur radius
                                                      offset: Offset(4.r,
                                                          4.r), // Position of the shadow
                                                    ),
                                                  ],
                                                  shape: BoxShape
                                                      .circle, // Optional: make the shadow circular
                                                ),
                                                child: Image.asset(
                                                  'assets/images/reward.png',
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 7.r),
                                            child: Text(
                                              allreward[index].title,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: opensans,
                                                  fontSize: 13.r,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 6.r),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                25))),
                                                backgroundColor: Colors.blue,
                                                foregroundColor: Colors.white,
                                                textStyle: TextStyle(
                                                    fontSize: 16.r,
                                                    fontFamily: opensans,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          RewardDetailScreen(
                                                              date: date,
                                                              data: allreward[
                                                                  index]),
                                                    ));
                                              },
                                              child: Text('Claim'),
                                            ),
                                          ),
                                        ]),
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
              return Container();
            }),
      ),
    );
  }
}
