import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../model/rewardmodel.dart';

class RewardDetailScreen extends StatefulWidget {
  final String date;
  final Datum data;

  const RewardDetailScreen({super.key, required this.date, required this.data});

  @override
  State<RewardDetailScreen> createState() => _RewardDetailScreenState();
}

class _RewardDetailScreenState extends State<RewardDetailScreen> {
  String opensans = 'OpenSans';

  late String description;
  late String title;
  late String rewardUrl;
  late String date;

  @override
  void initState() {
    super.initState();

    description = widget.data.description;
    title = widget.data.title;
    rewardUrl = widget.data.rewardUrl;
    date = formatDate(widget.date);
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      print(url);
      await launchUrl(Uri.parse(url), mode: LaunchMode.inAppBrowserView);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch $url'),
        ),
      );
    }
  }

  String formatDate(String inputDate) {
    DateTime InputDate = DateFormat('dd-MM-yyyy').parse(inputDate);

    String OutputDate = DateFormat('d MMM y').format(InputDate);
    return OutputDate;
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
        child: SafeArea(
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15.r, horizontal: 15.r),
              child: Column(children: [
                Center(
                  child: Image.asset(
                    'assets/images/reward.png',
                    height: 150.r,
                    fit: BoxFit.fill,
                  ),
                ),
                10.verticalSpace,
                Padding(
                  padding: EdgeInsets.only(top: 7.r),
                  child: Text(
                    title,
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: opensans,
                        fontSize: 22.r,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Divider(
                  color: Colors.black,
                  thickness: 3,
                ),
                Center(
                  child: Text(
                    date,
                    style: TextStyle(
                        fontSize: 22.r,
                        fontFamily: opensans,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                20.verticalSpace,
                Center(
                  child: Text(
                    softWrap: true,
                    description,
                    style: TextStyle(
                        fontSize: 22.r,
                        fontFamily: opensans,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                10.verticalSpace,
                Row(
                  children: [
                    Container(
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
                          print(rewardUrl);
                          _launchURL(rewardUrl);
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
                              padding: EdgeInsets.symmetric(
                                  vertical: 4.r, horizontal: 20.r),
                              child: Text(
                                'Claimed',
                                style: TextStyle(
                                    fontSize: 25.r,
                                    fontFamily: opensans,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    5.horizontalSpace,
                    Container(
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
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.r),
                          border: Border.all(width: 3.r, color: Colors.black),
                        ),
                        margin: EdgeInsets.all(4.r),
                        padding: EdgeInsets.only(bottom: 5.r),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 4.r, horizontal: 30.r),
                            child: Text(
                              'Share',
                              style: TextStyle(
                                  fontSize: 25.r,
                                  fontFamily: opensans,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                10.verticalSpace,
                Text(
                  'Note:After claiming your reward, you will be automatically redirected to the match Masters game. Enjoy your rewards and happy gaming!',
                  style: TextStyle(
                      fontSize: 22.r,
                      fontFamily: opensans,
                      color: Colors.yellowAccent,
                      fontWeight: FontWeight.bold),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
