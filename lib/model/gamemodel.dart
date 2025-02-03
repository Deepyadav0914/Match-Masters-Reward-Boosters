import 'dart:convert';

List<GameModel> gameModelFromJson(String str) =>
    List<GameModel>.from(json.decode(str).map((x) => GameModel.fromJson(x)));

String gameModelToJson(List<GameModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GameModel {
  String name;
  List<GameItemData> data;

  GameModel({
    required this.name,
    required this.data,
  });

  factory GameModel.fromJson(Map<String, dynamic> json) => GameModel(
        name: json["name"],
        data: List<GameItemData>.from(
            json["data"].map((x) => GameItemData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class GameItemData {
  String? name;
  String image;
  String description;
  String? title;

  GameItemData({
    this.name,
    required this.image,
    required this.description,
    this.title,
  });

  factory GameItemData.fromJson(Map<String, dynamic> json) => GameItemData(
        name: json["name"],
        image: json["image"] ?? "",
        description: json["description"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "image": image,
        "description": description,
        "title": title,
      };
}
