import 'dart:convert';
import 'package:meta/meta.dart';

import 'package:shared_preferences/shared_preferences.dart';

class NormalItasiRecord {
  DateTime recordedDate;
  int milliseconds;
  String comment;

  NormalItasiRecord({
    @required this.recordedDate,
    @required this.milliseconds,
    @required this.comment,
  });

  NormalItasiRecord.fromJson(Map<String, dynamic> json)
      : this.recordedDate = DateTime.parse(json["recordedDate"]),
        this.milliseconds = json["milliseconds"],
        this.comment = json["comment"];

  Map<String, dynamic> toJson() => {
        "recordedDate": recordedDate.toIso8601String(),
        "milliseconds": milliseconds,
        "comment": comment,
      };
}

class NormalItasiRecordPref {
  /// 取り出し
  static Future<List<NormalItasiRecord>> load() async {
    final pref = await SharedPreferences.getInstance();
    if (!pref.containsKey("normal_itashi")) {
      pref.setString("normal_itashi", "");
      return [];
    }

    if (pref.getString("normal_itashi").isEmpty) {
      return [];
    }

    List<Map<String, dynamic>> jsonList =
        json.decode(pref.getString("normal_itashi"));
    List<NormalItasiRecord> recordsList =
        jsonList.map((json) => NormalItasiRecord.fromJson(json)).toList();

    return recordsList;
  }

  /// 保存
  static Future save(List<NormalItasiRecord> records) async {
    final pref = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> jsons =
        records.map((record) => record.toJson()).toList();
    pref.setString("normal_itashi", json.encode(jsons));
  }

  /// 追加
  static Future addNewRecord(int time, String comment) async {
    final NormalItasiRecord newRecord = NormalItasiRecord(
      recordedDate: DateTime.now(),
      milliseconds: time,
      comment: comment,
    );
    final List<NormalItasiRecord> currentRecordsList =
        await NormalItasiRecordPref.load();
    currentRecordsList.add(newRecord);
  }
}
