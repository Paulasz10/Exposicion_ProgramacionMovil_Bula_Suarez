import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/dose_record.dart';
import '../../domain/repositories/dose_repository.dart';

class LocalDoseRepository implements DoseRepository {
  static const _key = 'meditag_doses_v1';
  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  @override
  Future<List<DoseRecord>> getAll() async {
    final jsonText = await _prefs.getString(_key);
    if (jsonText == null || jsonText.isEmpty) return [];
    final decoded = jsonDecode(jsonText) as List<dynamic>;
    final records = decoded
      .map((entry) => DoseRecord.fromJson(Map<String,dynamic>.from(entry as Map)))
      .toList();
    records.sort((a,b) => b.takenAt.compareTo(a.takenAt));
    return records;
  }

  @override
  Future<void> save(DoseRecord record) async {
    final existing = await getAll();
    if (existing.any((item) => item.id == record.id)) return;
    existing.add(record);
    await _prefs.setString(_key, jsonEncode(existing.map((e) => e.toJson()).toList()));
  }
}
