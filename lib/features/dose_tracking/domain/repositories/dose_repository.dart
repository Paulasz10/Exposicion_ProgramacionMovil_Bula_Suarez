import '../entities/dose_record.dart';

abstract class DoseRepository {
  Future<List<DoseRecord>> getAll();
  Future<void> save(DoseRecord record);
}
