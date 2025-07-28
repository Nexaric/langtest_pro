// To parse this JSON data, do
//
//     final progressModel = progressModelFromJson(jsonString);

import 'dart:convert';

ProgressModel progressModelFromJson(String str) => ProgressModel.fromJson(json.decode(str));

String progressModelToJson(ProgressModel data) => json.encode(data.toJson());

class ProgressModel {
    int id;
    List<String> progress;

    ProgressModel({
        required this.id,
        required this.progress,
    });

    factory ProgressModel.fromJson(Map<String, dynamic> json) => ProgressModel(
        id: json["id"],
        progress: List<String>.from(json["progress"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "progress": List<dynamic>.from(progress.map((x) => x)),
    };
}
