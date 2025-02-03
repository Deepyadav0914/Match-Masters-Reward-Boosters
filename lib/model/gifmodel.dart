import 'dart:convert';

GifsModel gifsModelFromJson(String str) => GifsModel.fromJson(json.decode(str));

String gifsModelToJson(GifsModel data) => json.encode(data.toJson());

class GifsModel {
  List<String> data;

  GifsModel({
    required this.data,
  });

  factory GifsModel.fromJson(Map<String, dynamic> json) => GifsModel(
        data: List<String>.from(json["data"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x)),
      };
}
