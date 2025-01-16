import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../model/gamemodel.dart';

class Detailscreen extends StatefulWidget {
  final String name;
  final GameItemData item;

  const Detailscreen({super.key, required this.name, required this.item});

  @override
  _DetailscreenState createState() => _DetailscreenState();
}

class _DetailscreenState extends State<Detailscreen> {
  String opensans = 'OpenSans';

  String title = "";

  @override
  Widget build(BuildContext context) {
    if (widget.item.title != null) {
      title = widget.item.title.toString();
    } else if (widget.item.name != null) {
      title = "";
    }

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
          widget.item.name == null ? "Details" : widget.item.name.toString(),
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
            child: Column(
              children: [
                10.verticalSpace,
                widget.item.image == ""
                    ? SizedBox()
                    : Padding(
                        padding: EdgeInsets.all(10.r),
                        child: Center(
                          child: Image.network(
                            widget.item.image,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                widget.name == "" &&
                        widget.item.name == "" &&
                        widget.item.title == ""
                    ? SizedBox()
                    : Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 15.r, horizontal: 15.r),
                        child: Column(
                          children: [
                            Center(
                              child: Padding(
                                padding: EdgeInsets.only(left: 20.r,right: 20.r),
                                child: Text(
                                  "${title}",
                                  style: TextStyle(
                                      fontSize: 25.r,
                                      fontFamily: opensans,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                            widget.item.title != null
                                ? Padding(
                                    padding: EdgeInsets.only(
                                        left: 18.r, right: 18.r),
                                    child: Divider(
                                      color: Colors.black,
                                      thickness: 3,
                                    ),
                                  )
                                : SizedBox(),
                            10.verticalSpace,
                            Text(
                              widget.item.description.toString(),
                              style: TextStyle(
                                  fontSize: 23.r,
                                  fontFamily: opensans,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
