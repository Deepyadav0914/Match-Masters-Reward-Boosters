import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../model/gamemodel.dart';

class Detailscreen extends StatefulWidget {
  final String name;
  final GameItemData item;

  Detailscreen({super.key, required this.name, required this.item});

  @override
  _DetailscreenState createState() => _DetailscreenState();
}

class _DetailscreenState extends State<Detailscreen> {
  String opensans = 'OpenSans';

  String title = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.item.title != null) {
      title = widget.item.title.toString();
    } else if (widget.item.name != null) {
      title = "";
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          widget.item.name.toString(),
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
          child: Column(
            children: [
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
                      padding: EdgeInsets.symmetric(vertical: 10.r),
                      child: Center(
                        child: Text(
                          "${title}",
                          style: TextStyle(
                              fontSize: 20.r,
                              fontFamily: opensans,
                              color: Colors.black87,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.r, vertical: 5.r),
                child: Text(
                  widget.item.description.toString(),
                  style: TextStyle(
                      fontSize: 20.r,
                      fontFamily: opensans,
                      color: Colors.black87,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  forCheckKey() {
    if (widget.item.title == "") {
      return "";
    } else if (widget.name == "") {
      return "";
    }
    return "";
  }
}
