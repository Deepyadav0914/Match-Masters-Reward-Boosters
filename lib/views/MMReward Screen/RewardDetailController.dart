import 'package:get/get.dart';
import '../../model/rewardmodel.dart';
import 'package:intl/intl.dart';

class RewardDetailController extends GetxController {
  final Datum reward;
  final String date;

  RewardDetailController(this.reward, this.date);

  String get description => reward.description;
  String get title => reward.title;
  String get rewardUrl => reward.rewardUrl;
  String get formattedDate => _formatDate(date);

  String _formatDate(String inputDate) {
    DateTime input = DateFormat('dd-MM-yyyy').parse(inputDate);
    return DateFormat('d MMM y').format(input);
  }




}
