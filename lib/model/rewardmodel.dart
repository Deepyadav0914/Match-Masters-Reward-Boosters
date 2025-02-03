import 'dart:convert';

RewardModel rewardModelFromJson(String str) =>
    RewardModel.fromJson(json.decode(str));

String rewardModelToJson(RewardModel data) => json.encode(data.toJson());

class RewardModel {
  List<MMreward> data;

  RewardModel({
    required this.data,
  });

  factory RewardModel.fromJson(Map<String, dynamic> json) => RewardModel(
        data:
            List<MMreward>.from(json["data"].map((x) => MMreward.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class MMreward {
  String title;
  String description;
  String image;
  String rewardUrl;
  String date;

  MMreward({
    required this.title,
    required this.description,
    required this.image,
    required this.rewardUrl,
    required this.date,
  });

  factory MMreward.fromJson(Map<String, dynamic> json) => MMreward(
        title: json["title"]!,
        description: json["description"],
        image: json["image"]!,
        rewardUrl: json["rewardURL"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "image": image,
        "rewardURL": rewardUrl,
        "date": date,
      };
}
