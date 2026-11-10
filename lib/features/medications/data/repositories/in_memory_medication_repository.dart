import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/medication.dart';
import '../../domain/repositories/medication_repository.dart';
/// Maintains the earlier class name to preserve existing module imports,
/// but uses local browser/device storage instead of an in-memory list.
class InMemoryMedicationRepository implements MedicationRepository {
  static const _key='meditag_medications_v2';
  final SharedPreferencesAsync _prefs=SharedPreferencesAsync();
  final List<Medication> _defaults=const [
    Medication(id:'demo-a',name:'Medicamento A (ejemplo)',dosage:'Dosis de demostración',schedule:'08:00',tagId:'ETIQUETA_BLANCA'),
    Medication(id:'demo-b',name:'Medicamento B (ejemplo)',dosage:'Dosis de demostración',schedule:'18:00',tagId:'ETIQUETA_CIRCULAR'),
  ];
  Map<String,dynamic> _json(Medication m)=>{'id':m.id,'name':m.name,'dosage':m.dosage,'schedule':m.schedule,'tagId':m.tagId};
  Medication _from(Map<String,dynamic> m)=>Medication(id:m['id'] as String,name:m['name'] as String,dosage:m['dosage'] as String,schedule:m['schedule'] as String,tagId:m['tagId'] as String?);
  @override Future<List<Medication>> getAll() async {
    final value=await _prefs.getString(_key);
    if(value==null) return List.of(_defaults);
    final data=jsonDecode(value) as List<dynamic>;
    return data.map((e)=>_from(Map<String,dynamic>.from(e as Map))).toList();
  }
  Future<void> _write(List<Medication> items)=>_prefs.setString(_key,jsonEncode(items.map(_json).toList()));
  @override Future<void> save(Medication medication) async {
    final items=await getAll();
    final index=items.indexWhere((m)=>m.id==medication.id);
    if(index==-1){items.add(medication);}else{items[index]=medication;}
    await _write(items);
  }
  @override Future<void> delete(String id) async {final items=await getAll();items.removeWhere((m)=>m.id==id);await _write(items);}
}
