import 'dart:developer';
import 'package:get/get.dart';
import '../../api/menuapi.dart';
import '../../model/gamemodel.dart';

class DataScreenController extends GetxController {
  RxList<GameItemData> alldata = <GameItemData>[].obs;
  final RxString _name = ''.obs;
  String opensans = 'OpenSans';

  @override
  void onInit() {
    super.onInit();
    alldata.value = Get.arguments['data'];
    log('alldata');
    _name.value = Get.arguments['name'];
    log('_name');
    fetchData();
  }

  String? get title => alldata[0].title;
  String get name => _name.value;

  // Fetch GIFs data
  void fetchData() {
    ApiCall().fetchData();
  }

  // Retry logic
  void retry() {
    fetchData();
  }
}
