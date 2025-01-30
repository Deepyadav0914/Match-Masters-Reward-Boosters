// import 'package:get/get.dart';
// import '../../model/rewardmodel.dart';
// import 'package:intl/intl.dart';
//
// class RewardDetailController extends GetxController {
//   RxList<MMreward> reward = <MMreward>[].obs;
//   RxString date = ''.obs;
//   RxString rewardKey = ''.obs;
//   RxInt index = 0.obs;
//   String opensans = 'OpenSans';
//   int rewardCoins = 150;
//
//   @override
//   void onInit() {
//     var rewardData = Get.arguments['data'];
//     if (rewardData is MMreward) {
//       reward.value = [rewardData];
//       print(reward[0].title);
//     }
//     print(rewardData);
//     date.value = Get.arguments['date'];
//     print(date.value);
//     index.value = Get.arguments['index'];
//     print(index.value);
//     super.onInit();
//   }
//
//   String get description => reward[0].description;
//   String get title => reward[0].title;
//   String get formattedDate => _formatDate(date.value);
//
//   String _formatDate(String inputDate) {
//     DateTime input = DateFormat('dd-MM-yyyy').parse(inputDate);
//     return DateFormat('d MMM y').format(input);
//   }
//   // // Method to initialize coins from local storage
//   void initializeClaimed() {
//     // Load claimed or default to false
//
//
//   }
//
//   //
//   //
//   // // Method to collect reward coins
//   // void rewardClaimed() {
//   //
//   //   saveCoins(); // Save updated coins to local storage
//   //   print("Total coins: ${totalCoins.value}");
//   // }
//   //
//   // // Save totalCoins to local storage
//   // void saveCoins() {
//   //   box.write('totalCoins', totalCoins.value);
//   // }
//   //
// }

import 'package:get/get.dart';
import '../../main.dart';
import '../../model/rewardmodel.dart';
import 'package:intl/intl.dart';

class RewardDetailController extends GetxController {
  RxList<MMreward> reward = <MMreward>[].obs;
  RxString date = ''.obs;
  RxString rewardKey = ''.obs;
  RxInt index = 0.obs;
  String opensans = 'OpenSans';
  int rewardCoins = 150;

  @override
  void onInit() {
    var rewardData = Get.arguments['data'];
    if (rewardData is MMreward) {
      reward.value = [rewardData];
      print(reward[0].title);
    }
    print(rewardData);
    date.value = Get.arguments['date'];
    print(date.value);
    index.value = Get.arguments['index'];
    print(index.value);
    //initializeClaimed();
    super.onInit();
  }

  String get description => reward[0].description;
  String get title => reward[0].title;
  String get formattedDate => _formatDate(date.value);

  String _formatDate(String inputDate) {
    DateTime input = DateFormat('dd-MM-yyyy').parse(inputDate);
    return DateFormat('d MMM y').format(input);
  }
//
//   // // Method to initialize coins from local storage
//   void initializeClaimed() {
//     // Load claimed or default to false
//
//         box.read<Map<String, dynamic>>('claimedRewards') ?? {};
//     print("is claimed == $claimedRewards");
//   }
//
//
//
// // Method to collect reward coins
// void rewardClaimed() {
//   String uniqueKey =
//       "${controller.title}_${controller.date}_${controller.index}";
//   print("uniqueKey == ${uniqueKey}");
//   bool isClaime = initializeClaimed().uniqueKey ?? false;
//   saveClaimed(); // Save updated coins to local storage
//
// }
//
// // Save totalCoins to local storage
// void saveClaimed() {
//   box.write('claimedRewards');
// }

}
