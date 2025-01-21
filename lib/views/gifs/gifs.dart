import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:matchapp/api/menuapi.dart';
import 'package:matchapp/views/gifs/gifsDetail.dart';

import '../../model/gifmodel.dart';

class GifsScreen extends StatefulWidget {
  List<String> data;

  GifsScreen({super.key, required this.data});

  @override
  State<GifsScreen> createState() => _GifsScreenState();
}

class _GifsScreenState extends State<GifsScreen> {
  late Future<GifsModel> _gifsData;
  String opensans = 'OpenSans';

  @override
  void initState() {
    _gifsData = ApiCall().gifsData();
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
          'Top GIFs',
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
        child: FutureBuilder<GifsModel>(
          future: _gifsData,
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
                          _gifsData = ApiCall().gifsData();
                        });
                      },
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasData) {
              final allgifs = snapshot.data!.data;

              return SafeArea(
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(
                        height: (allgifs.length / 2).ceil() * 190.r,
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
                            itemCount: allgifs.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.r),
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
                                                  GifsDetailScreen(data: allgifs[index],)));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(11.r),
                                        border: Border.all(
                                            width: 3.r, color: Colors.black),
                                      ),
                                      margin: EdgeInsets.all(4.r),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Center(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 12.r),
                                                child: CachedNetworkImage(
                                                  placeholder: (context, url) {
                                                    return LoadingAnimationWidget
                                                        .threeArchedCircle(
                                                      color: Colors.black45,
                                                      size: 20.sp,
                                                    );
                                                  },
                                                  imageUrl:
                                                      allgifs[index].toString(),
                                                ),
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
                  ),
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
