import 'dart:developer';
import 'package:get/get.dart';
import '../../model/gamemodel.dart';

class DetailscreenController extends GetxController {
  GameItemData? item;
  String opensans = 'OpenSans';

  @override
  void onInit() {
    super.onInit();
    item = Get.arguments['data'];
    log('_item.value');
  }
}
