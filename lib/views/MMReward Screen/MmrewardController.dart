import 'package:get/get.dart';
import 'package:matchapp/api/menuapi.dart';
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
}
