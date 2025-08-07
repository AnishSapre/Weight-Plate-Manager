import 'dart:convert';
import "package:shared_preferences/shared_preferences.dart";
import '../models/lift_history.dart';

class LiftHistoryService {
  static const String _historyKey = 'lift_history';
  final SharedPreferences _prefs;

  LiftHistoryService(this._prefs);

  Future<void> addLift(LiftHistory lift) async {
    final List<LiftHistory> history = await getLiftHistory();
    history.add(lift);
    await _saveHistory(history);
  }

  Future<List<LiftHistory>> getLiftHistory() async {
    final String? historyJson = _prefs.getString(_historyKey);
    if (historyJson == null) return [];

    final List<dynamic> historyList = json.decode(historyJson);
    return historyList.map((item) => LiftHistory.fromMap(item)).toList();
  }

  Future<void> _saveHistory(List<LiftHistory> history) async {
    final List<Map<String, dynamic>> historyList = history.map((lift) => lift.toMap()).toList();
    await _prefs.setString(_historyKey, json.encode(historyList));
  }
} 