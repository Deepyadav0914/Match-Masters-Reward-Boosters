import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String opensans = 'OpenSans';

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
          'Settings',
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: SafeArea(
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: MenuList.menuList.length,
            padding: EdgeInsets.symmetric(vertical: 15.r, horizontal: 15.r),
            itemBuilder: (context, index) {
              var menulist = MenuList.menuList[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22.r),
                  border: Border.all(width: 3.r, color: Colors.black),
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
                    borderRadius: BorderRadius.circular(18.r),
                    border: Border.all(width: 3.r, color: Colors.black),
                  ),
                  margin: EdgeInsets.all(4.r),
                  padding: EdgeInsets.all(6.r),
                  child: ListTile(
                    onTap: () {
                      if (index == 0) {
                      } else if (index == 1) {
                      } else if (index == 2) {
                      } else if (index == 3) {}
                    },
                    title: Center(
                      child: Text(
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
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class SettingList {
  final String name;

  SettingList({required this.name});
}

class MenuList {
  static final menuList = [
    SettingList(name: 'Privacy Policy'),
    SettingList(name: 'Contact Us'),
    SettingList(name: 'Share App'),
    SettingList(name: 'Rate Us'),
  ];
}
