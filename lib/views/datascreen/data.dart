import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../model/gamemodel.dart';
import '../details/details.dart';

class DataScreen extends StatelessWidget {
  final String name;
  final List<GameItemData> data;
  String opensans = 'OpenSans';


  DataScreen({super.key, required this.name, required this.data});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading:
        IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back,color: Colors.white,),),
        backgroundColor: Colors.blue,
        title: Text(
          name,
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
              name == 'Tips & Tricks' || name == 'FAQs'
                  ? forListView()
                  : Expanded(
                      child: SizedBox(
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          itemCount: data.length,
                          padding: EdgeInsets.symmetric(
                              vertical: 20.r, horizontal: 20.r),
                          itemBuilder: (context, index) {
                            final item = data[index];
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
                                    blurRadius: 15.r,
                                  ),
                                ],
                              ),
                              margin: EdgeInsets.symmetric(
                                  vertical: 10.r, horizontal: 10.r),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(11.r),
                                  border: Border.all(
                                      width: 3.r, color: Colors.black),
                                ),
                                margin: EdgeInsets.all(4.r),
                                padding: EdgeInsets.only(bottom: 5.r),
                                child: ListTile(
                                  onTap: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Detailscreen(
                                          name: name.toString(),
                                          item: item,
                                        ),
                                      ),
                                    );
                                  },
                                  title: Center(
                                    child: Padding(
                                      padding:  EdgeInsets.symmetric(vertical: 7.r),
                                      child: Image.network(
                                        data[index].image.toString(),
                                        height: double.infinity,
                                        width: double.infinity,
                                        fit: BoxFit.fill,
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
            ],
          ),
        ),
      ),
    );
  }

  forListView() {
    return Expanded(
      child: SizedBox(
        child: ListView.builder(
          itemCount: data.length,
          padding: EdgeInsets.symmetric(vertical: 15.r, horizontal: 15.r),
          itemBuilder: (context, index) {
            final item = data[index];

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(width: 3.r, color: Colors.black),
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
                  border: Border.all(width: 3.r, color: Colors.black),
                ),
                margin: EdgeInsets.all(4.r),
                child: ListTile(
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Detailscreen(
                          name: name.toString(),
                          item: item,
                        ),
                      ),
                    );
                  },
                  leading: Text(
                    '${index+1}.',
                    style: TextStyle(
                      fontFamily: opensans,
                      fontSize: 24.r,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  title: Text(
                    overflow: TextOverflow.ellipsis,
                    item.title.toString(),
                    style: TextStyle(
                      fontFamily: opensans,
                      fontSize: 24.r,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.black,
                    weight: 5.r,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
