// import 'package:get/get.dart';
// import 'package:matchapp/api/menuapi.dart';
// import 'package:matchapp/model/rewardmodel.dart';
// import 'package:intl/intl.dart';
//
// class MmrewardController extends GetxController {
//   RxString date = ''.obs;
//   var rewardData = RewardModel(data: []).obs;
//   RxBool isLoading = true.obs;
//   String opensans = 'OpenSans';
//
//
//   @override
//   void onInit() {
//     fetchRewardData();
//     super.onInit();
//   }
//
//   Future<void> fetchRewardData() async {
//     try {
//       isLoading(true);
//       final data = await ApiCall().rewardData();
//       rewardData.value = data;
//     } catch (e) {
//       Get.snackbar("Error", "Failed to load data. Please try again.");
//     } finally {
//       isLoading(false);
//     }
//   }
//
//   String formatDate(int timestamp) {
//     DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
//     return DateFormat('dd-MM-yyyy').format(date).toLowerCase();
//   }
// }

import 'package:get/get.dart';
import 'package:matchapp/api/menuapi.dart';
import 'package:matchapp/main.dart';
import 'package:matchapp/model/rewardmodel.dart';
import 'package:intl/intl.dart';

class MmrewardController extends GetxController {
  RxString date = ''.obs;
  var rewardData = RewardModel(data: []).obs;
  RxBool isLoading = true.obs;
  String opensans = 'OpenSans';
  RxBool isClaimed = false.obs;

  @override
  void onInit() {
    fetchRewardData();
    super.onInit();
  }

  Future<void> fetchRewardData() async {
    try {
      isLoading(true);
      final data = await ApiCall().rewardData();

      rewardData.value = data;
    } catch (e) {
      Get.snackbar("Error", "Failed to load data. Please try again.");
    } finally {
      isLoading(false);
    }
  }

  String formatDate(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('dd-MM-yyyy').format(date).toLowerCase();
  }

  // void claimReward(String date, var reward) {
  //   final uniqueKey = generateUniqueKey(reward.date, reward.title);
  //   reward = true; // Mark reward as claimed
  //   box.write(uniqueKey, true); // Save claim status in storage
  //   update();
  // }
  //
  String generateUniqueKey(String date, String title) {
    print("$date-$title");
    return "$date-$title"; // Combine date and title as a unique key
  }

  // Method to initialize claimed from local storage
  void initializeClaimed() {
    isClaimed.value = box.read<bool>('isClaimed') ?? false;
    // Load coins or default to 0
  }

  // Method to collect reward claimed
  void claimedReward(String date, var reward) {
    final uniqueKey = generateUniqueKey(date, reward);
    isClaimed.value = true; // Mark reward as claimed
    box.write(uniqueKey, true); // Save claim status in storage
    print("Total claim: ${isClaimed.value}");
  }
}
