import 'package:get/get.dart';
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
    super.onInit();
  }

  String get description => reward[0].description;
  String get title => reward[0].title;
  String get formattedDate => _formatDate(date.value);

  String _formatDate(String inputDate) {
    DateTime input = DateFormat('dd-MM-yyyy').parse(inputDate);
    return DateFormat('d MMM y').format(input);
  }
}

// import 'package:get/get.dart';
// import '../../main.dart';
// import '../../model/rewardmodel.dart';
// import 'package:intl/intl.dart';
//
// import '../Gifs Screen/GifsController.dart';
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
//     updateClaimedRewards('uniqueKey');
//     super.onInit();
//   }
//
//   String get description => reward.isNotEmpty ? reward[0].description : '';
//   String get title => reward.isNotEmpty ? reward[0].title : '';
//   String get formattedDate => _formatDate(date.value);
//
//   String _formatDate(String inputDate) {
//     try {
//       DateTime input = DateFormat('dd-MM-yyyy').parse(inputDate);
//       return DateFormat('d MMM y').format(input);
//     } catch (e) {
//       print('Error parsing date: $e');
//       return inputDate;
//     }
//   }
//
//   void updateClaimedRewards(String uniqueKey) {
//     var claimedRewards = box.read<Map<String, dynamic>>('claimedRewards') ?? {};
//     claimedRewards[uniqueKey] = true;
//     box.write("claimedRewards", claimedRewards);
//     refresh();
//   }
//
//   bool isRewardClaimed(String uniqueKey) {
//     var claimedRewards = box.read<Map<String, dynamic>>('claimedRewards') ?? {};
//     return claimedRewards[uniqueKey] ?? false;
//   }
//
//   void collectRewardCoins() {
//     final gifsController = Get.put(GifsController());
//     gifsController.collectCoins(rewardCoins);
//   }
// }
