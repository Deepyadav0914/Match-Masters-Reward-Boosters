import 'dart:convert';

RewardModel rewardModelFromJson(String str) => RewardModel.fromJson(json.decode(str));

String rewardModelToJson(RewardModel data) => json.encode(data.toJson());

class RewardModel {
  List<Datum> data;

  RewardModel({
    required this.data,
  });

  factory RewardModel.fromJson(Map<String, dynamic> json) => RewardModel(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String title;
  String description;
  String image;
  String rewardUrl;
  String date;

  Datum({
    required this.title,
    required this.description,
    required this.image,
    required this.rewardUrl,
    required this.date,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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






