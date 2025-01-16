import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:matchapp/model/gamemodel.dart';

import '../datascreen/data.dart';


class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late Future<List<GameModel>> _gameData;
  String opensans = 'OpenSans';

  List images = [
    'assets/images/modes.png',
    'assets/images/modifiers.png',
    'assets/images/studios.png',
    'assets/images/book.png',
    'assets/images/faq.png',
  ];

  @override
  void initState() {
    super.initState();
    _gameData = fetchData();
  }

  Future<List<GameModel>> fetchData() async {
    try {
      var response = await Dio().get(
          'https://miracocopepsi.com/admin/mayur/coc/pradip/ios/mm_rewards/data.json');

      if (response.statusCode == 200) {

          return gameModelFromJson(json.encode(response.data));

      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
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
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.white),
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
                                    _gameData = fetchData();
                                  });
                                },
                                child: const Text("Retry"),
                              ),
                            ],
                          ),
                        );
                      } else if (snapshot.hasData) {
                        final alldata = snapshot.data;

                        return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: alldata?.length,
                          padding: EdgeInsets.symmetric(
                              vertical: 15.r, horizontal: 15.r),
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14.r),
                                border:
                                    Border.all(width: 3.r, color: Colors.black),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black,
                                    offset: Offset(6.r, 6.r),
                                    blurRadius: 20.r,
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
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DataScreen(
                                            data:  alldata[index].data, name: alldata[index].name,
                                          ),
                                        ));
                                  },
                                  leading: Image(
                                    image: AssetImage(images[index]),
                                  ),
                                  title: Text(
                                    alldata![index].name.toString(),
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
