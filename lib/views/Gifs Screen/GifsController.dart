import 'package:get/get.dart';
import '../../api/menuapi.dart';
import '../../main.dart';
import '../../model/gifmodel.dart';

class GifsController extends GetxController {
  // Reactive future for GIFs data
  late Rx<Future<GifsModel>> gifsData;

  // Total coins stored reactively
  RxInt totalCoins = 0.obs;
  RxInt index = 0.obs;
  int rewardCoins = 150;

  @override
  void onInit() {
    super.onInit();
    fetchGifsData();
    initializeCoins(); // Initialize coins from storage
  }

  // Fetch GIFs data
  void fetchGifsData() {
    gifsData = ApiCall().gifsData().obs;
  }

  // Method to initialize coins from local storage
  void initializeCoins() {
    totalCoins.value =
        box.read<int>('totalCoins') ?? 0; // Load coins or default to 0
  }

  // Method to collect reward coins
  void collectCoins(int coins) {
    totalCoins.value += coins;
    saveCoins(); // Save updated coins to local storage
    print("Total coins: ${totalCoins.value}");
  }

  // Method to unloacked Gifs
  void unlockedGifs(int coins) {
    totalCoins.value -= coins;
    saveCoins(); // Save updated coins to local storage
    print("Total coins: ${totalCoins.value}");
  }

  // Save totalCoins to local storage
  void saveCoins() {
    box.write('totalCoins', totalCoins.value);
  }

  // Retry logic
  void retry() {
    fetchGifsData();
  }
}
